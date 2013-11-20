(* ::Package:: *)

#!/usr/local/bin/MathKernel -script

searchword=$CommandLine[[4]];
lines={};

sparkline[data_]:=DateListPlot[data,{1997},FrameTicks->{{Automatic,Automatic},{{{2007,1,15},Red}},None},Axes->False,Frame->False,Joined->True,PlotRange->All,Filling->Bottom,AspectRatio->0.2,ImageSize->120];

distance=5; (* set amount of lines from WARC you want to analyze *)

AppendTo[lines,Import["fulltext.txt",{"Lines",Range[1,distance]}]];

(* need to generate list of stopwords *)
out=StringSplit[ToLowerCase[#],Except[WordCharacter]..]&/@lines;
wordpressstop={"0","1","11","15","2","200","2013","22","30","50","59","8","automattic","ca","charset","chunked","com","content","crawl","encoding","nginx","php","type","use","utf","visit","was","wed","wordpress","wp","x","xml","html",,"png","gif","http","span","0000","href","height","width","text","server","gmt","xmlrpc","www","feed","em","re","ve","src","13"} ; (* from header info, obtained by Intersection[out[[1]],out[[2]]]*)
regstop=WordData[All,"Stopwords"]; (* WordData stopwords *)
stopwords=DeleteDuplicates[Join[wordpressstop,regstop]];

string=Map[ToLowerCase,StringSplit[ToString[Flatten[lines]],Except[WordCharacter]..]];
stringnostop=Select[string,Not[MemberQ[stopwords,#]]&];
frequencylist=Sort[Tally[stringnostop],#1[[2]]>#2[[2]]&];
setup=Partition[string,7,1];

title=StringDrop[StringCases[First[Flatten[lines]],Shortest["http://"|"https://"~~___~~"HTTP/1.1"]],-8]<>" WARC"; (* change to regex *)
x=Flatten[StringPosition[First[Flatten[lines]],"Date:"]][[1]];
date=StringTake[First[Flatten[lines]],{x,x+35}];

x=Flatten[StringPosition[First[Flatten[lines]],"Connection:"]][[1]];
preview=StringTake[First[Flatten[lines]],{x,x+1500}];

(* word cloud script, courtesy StackExchange - thanks everybody! *)
(* CONSIDERATION: replace Word Cloud with just a sorted frequency list? Might be more rigorous but eliminates the speed aspect. *)

iteration[img1_,w_,fun_: (Norm[#1-#2]&)]:=Module[{imdil,centre,diff,dimw,padding,padded1,minpos},dimw=ImageDimensions[w];
padded1=ImagePad[img1,{dimw[[1]] {1,1},dimw[[2]] {1,1}},1];
imdil=MaxFilter[Binarize[ColorNegate[padded1],0.01],Reverse@Floor[dimw/2+2]];
centre=ImageDimensions[padded1]/2;
minpos=Reverse@Nearest[Position[Reverse[ImageData[imdil]],0],Reverse[centre],DistanceFunction->fun][[1]];
diff=ImageDimensions[imdil]-dimw;
padding[pos_]:=Transpose[{#,diff-#}&@Round[pos-dimw/2]];
ImagePad[#,(-Min[#] {1,1})&/@BorderDimensions[#]]&@ImageMultiply[padded1,ImagePad[w,padding[minpos],1]]];

tally=Take[frequencylist,100];
tally=Cases[tally,_?(Last@#>10&)]; (* building off of a stopword removed frequency list *)
tally=Reverse@SortBy[tally,Last];
range={Min@(Last/@tally),Max@(Last/@tally)};

words=Style[First@#,FontFamily->"Cracked",FontWeight->Bold,FontColor->Hue[RandomReal[],RandomReal[{.5,1}],RandomReal[{.5,1}]],FontSize->Last@Rescale[#,range,{12,70}]]&/@tally;
wordsimg=ImageCrop[Image[Graphics[Text[#]]]]&/@words;
Fold[iteration,wordsimg[[1]],Rest[wordsimg]];

input=Drop[Drop[Import["warc_Composition.txt","Table"],1],None,1];
keys=Import["warc_keys.txt","Lines"];

topics={}; (** here we are building the frequency for each file - i.e. for each 8612 tweets, we are building a list of topic frequencies **)
tr=Range[1,50]; (** reflects number of topics **)
Do[
yearcount={}; (** year variable reflects that most of my projects are in years **)
x=1;
Do[
var=Take[data,{x,x+1}];
AppendTo[yearcount,var];
,{x,tr}];
AppendTo[topics,yearcount];
,{data,input}];
overallcount={}; (** now we're getting an overall count for how often each TOPIC appears **)
Do[
count={};
Do[
output=Cases[topics[[x]],{y,_}];
AppendTo[count,output];
,{x,Range[1,Length[topics]]}];
AppendTo[overallcount,count];
,{y,Range[0,49]}];

graphlist={};
 Do[
AppendTo[graphlist,overallcount[[y]]];
,{y,Range[1,50]}];
complist={};
 
(** putting it in a graphable form **)
Do[
results=If[#==={},0,#1[[1,2]]]&/@graphlist[[x]];
AppendTo[complist,results];
,{x,Range[1,50]}];
bucket={};
Do[
new={x,StringDrop[keys[[x]],4],sparkline[MovingAverage[complist[[x]],20]]};
AppendTo[bucket,new];
,{x,Range[1,50]}];
means={};
Do[
AppendTo[means,Mean[Flatten[overallcount[[x]],1][[All,2]]]];
,{x,Length[overallcount]}] ;

(** so this command then ranks the topics in order of their average means - to find out which ones are the most common overall **)

topicinorder={};
 
(** this puts them in order **)
Do[
AppendTo[topicinorder,Position[means,Sort[means,Greater][[x]]]];
,{x,Length[means]}];

topicorder=Flatten[topicinorder];

relbucket={};
Do[
new={x,StringDrop[keys[[x]],4],sparkline[complist[[x]]]}; (** the data here was actually listed wrong, it was ordered most recent to oldest, so I used Reverse[] to make it look pretty when displaying. If your info is in the right order, just get rid of the Reverse[] above **)
AppendTo[relbucket,new];
,{x,topicorder}];
relbucket//Grid;
output1=TableForm[Cases[DeleteDuplicates[setup],{_,_,_,searchword,_,_,_}],TableHeadings->{None,{"L1","L2","L3","WORD","R1","R2","R3"}}] ;(* remove Delete Duplicates to get a comprehensive sense of things *)(* KWIC *)
people=Import["fulltext_ner_pers_freq.txt","Lines"];
locations=Import["fulltext_ner_loc_freq.txt","Lines"];
organizations=Import["fulltext_ner_org_freq.txt","Lines"];

results=Column[{Style[title,"Title"],Style[date,"Subsection"]," "Style["Preview:","Subsection"],preview,"",Style["Word Cloud","Subsection"],"",Fold[iteration,wordsimg[[1]],Rest[wordsimg]] ,""Style["Keyword-in-Context","Subsection"],output1,"",Style["Top 50 People","Subsection"],Take[people,50],Style["Top 50 Locations","Subsection"],Take[locations,50],Style["Top 50 Organizations","Subsection"],Take[organizations,50],Style["Topic Models: (more useful on multiple documents)","Subsection"],Take[relbucket,50]//Grid}]; (* slow down is the Fold[iteration, etc. command that creates Word Cloud, could delete and replace with word frequency for speed *)

Export["/users/ianmilligan1/desktop/trial-1.pdf",results];
