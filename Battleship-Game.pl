%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Is true if each l in the list is followed by an r or it's a list with a singular element l
mycheck([]).
mycheck([l]).
mycheck([H|T]):- mycheckH([H|T]).
%Is true if each l in the list is followed by an r
mycheckH([]).
mycheckH([H|T]):-
                 (H=c;H=w),
                 mycheckH(T).
mycheckH([H1,H2|T]):-
                     H1=l,H2=r,mycheckH(T).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% insert element in the last position of list
addelement([],X,[X]).
addelement([H|T],X,L):-
addelement(T,X,L1),L=[H|L1].

%Is true if third paramater is the first paramater (List) converted into a list of lists with length of 2nd paramter each
list_to_llists([],_,[]).
list_to_llists([],_,[]).
list_to_llists([H|T],X,L):-
listhelper([H|T],0,[],X,L).

% conisder as helper method  (acculamator) use addelement to make sublist of size w then accumalate it to list L so o produce list of list  
listhelper([],_,S,X,[]):-
length(S,L1),L1\=X.
listhelper([],_,S,X,[S]):-
length(S,L1),L1==X.
listhelper([H|T],C,S,X,L):-
C\=X,C1 is C+1,addelement(S,H,S1),listhelper(T,C1,S1,X,L).
listhelper([H|T],C,S,X,L):-
C==X,listhelper([H|T],0,[],X,L1),L=[S|L1].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Is true if 2nd paramater is the first element of the list in first paramater
getZeroth([H|_],E1):-
                     H=E1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Is true if 2nd paramater is the list in first paramter excluding the first element
rest([_|T],T).
rest([],[]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Is true if 4th paramater is the sublist of the 3rd paramater from index of first paramater to 2nd paramater
sublist(I1,I2,L,Sub):-
counthelper(I1,I2,0,L,Sub).
% counthelper is considered as accumalator method take element of specific      INDEX
counthelper(_,_,_,[],[]).
counthelper(_,Y,C,_,[]):-
C is Y+1.
counthelper(X,Y,C,[_|T],L):-
C<X,C1 is C+1,counthelper(X,Y,C1,T,L).
counthelper(X,Y,C,[H|T],L):-
C>=X,C=<Y,C1 is C+1,counthelper(X,Y,C1,T,L1),L=[H|L1].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Facts detailing the hints given for collect_hints
at(5,0,w).
at(3,5,c).
at(9,6,c).
% at(0,0,w).
% at(2,0,c).
% at(2,1,r).
%Is true if H is the list of facts given in the grid
collect_hints(H):-
setof(at(X,Y,Z),at(X,Y,Z),H).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Is true if the list facts in 2nd paramater holds in the grid in 1st paramater of width W and height H
ensure_hints(_,[],_,_).
ensure_hints(L,[at(A,B,C)|RH],W,H):-
                                    I is A + (W*B),
                                    nth0(I,L,C),
                                    ensure_hints(L,RH,W,H).
                                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Is true if it's paramater is any list consisting of only w,c,l or r
random_assignment([]).
random_assignment([H|T]):-
                                member(H,[w,c,l,r]),
                                random_assignment(T).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Is true if each row in the grid has a number of vessels that is equal to the corresponding value in the 4th paramater
check_rows([],_,_,_):-!.
check_rows([H1|T],W,_,[S|RS]):-
                               check_rowsH([H1|T],W,0,0,[S|RS]).
%Is true if each row in the grid has a number of vessels that is equal to the corresponding value in the 5th paramater and uses the 3rd and 4th paramaters as a counter to determine when a the end of a row has been reached and as an accumulator to check the number of vessels in the row respectively
check_rowsH([],_,_,_,_):-!.
check_rowsH([H1|T],W,C,A,[S|RS]):-
                                  H1\=w,
                                  H1\=l,
                                  C<W,
                                  A1 is A+1,
                                  C1 is C+1,
                                  check_rowsH(T,W,C1,A1,[S|RS]).
check_rowsH([H1|T],W,C,A,[S|RS]):-
                                  H1=w,
                                  C<W,
                                  A1 is A,
                                  C1 is C+1,
                                  check_rowsH(T,W,C1,A1,[S|RS]).
check_rowsH([H1,H2|T],W,C,A,[S|RS]):-
                                     H1=l,
                                     H2=r,
                                     Temp is C+1,
                                     Temp<W,
                                     A1 is A+2,
                                     C1 is C+2,
                                     check_rowsH(T,W,C1,A1,[S|RS]).
check_rowsH(L,W,C,A,[S|RS]):-
                                 C=W,
                                 A=S,
                                 check_rowsH(L,W,0,0,RS).
check_rowsH([l],_,_,_,_):-!.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Is true if each column in the grid has a number of vessels that is equal to the corresponding value in the 4th paramater
check_columns([],_,_,_):-!.
check_columns(L,W,_,_):-
                             list_to_llists(L,W,LL),
                             flatten(LL,LLL),
                             LLL=[].
check_columns(L,W,H,[S|RS]):-
                             list_to_llists(L,W,LL),
                             flatten(LL,LLL),
                             LLL\=[],
                             check_columnsH(LLL,W,H,0,0,0,0,[S|RS]).
%Is true if each column in the grid has a number of vessels that is equal to the corresponding value in the 8th paramater and FI keeps track of the index of the column that is being tested at the moment, I keeps track of the index of the element in the column that should be checked and uses the C and A paramaters as a counter to determine when a the end of a column has been reached and as an accumulator to check the number of vessels in the column respectively
check_columnsH(_,_,_,_,_,_,_,[]).
check_columnsH(L,W,H,I,FI,A,C,[S|RS]):-
                                    C<H,
                                    nth0(I,L,E),
                                    E\=w,
                                    A1 is A+1,
                                    I1 is I+W,
                                    C1 is C+1,
                                    check_columnsH(L,W,H,I1,FI,A1,C1,[S|RS]).
check_columnsH(L,W,H,I,FI,A,C,[S|RS]):-
                                    C<H,
                                    nth0(I,L,E),
                                    E=w,
                                    A1 is A,
                                    I1 is I+W,
                                    C1 is C+1,
                                    check_columnsH(L,W,H,I1,FI,A1,C1,[S|RS]).
check_columnsH(L,W,H,_,FI,A,C,[S|RS]):-
                                    C=H,
                                    C1=0,
                                    FI1 is FI+1,
                                    I1 is FI1,
                                    A=S,
                                    check_columnsH(L,W,H,I1,FI1,0,C1,RS).

                                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%counts an element in a list
count([H|T],E,A,C):-
                    H=E,
                    A1 is A+1,
                    count(T,E,A1,C).
count([H|T],E,A,C):-
                    H\=E,
                    count(T,E,A,C).
count([],_,A,A).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Is true if the list L of width W and height H has a number of subs (c) TotalSub
check_submarines(L,_,_,_):-
L==[].
check_submarines(L,W,H,TotalSub):-
L\=[],check_submarines1(L,W,H,TotalSub).
% check_submarines1 same function as check_submarine
% I just do it check_submarines1 if list (L) is empty so no need to check 2nd perdicate of check_submarines instead of use of cut 
check_submarines1([],_,_,0).
check_submarines1([H1|T1],W,H,TotalSub):-
H1==c,check_submarines1(T1,W,H,C1),TotalSub is C1+1.
check_submarines1([H1|T1],W,H,TotalSub):-
H1\=c,check_submarines1(T1,W,H,TotalSub).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Is true if mycheckdes is true for each element in the list
mycheckforeach([]).
mycheckforeach([H|T]):-
                       mycheckdes(H),
                       mycheckforeach(T).
%Is true if each l in the list is followed by an r, similiar to mycheck
mycheckdes([]):-!.
mycheckdes([A]):-
                 A\=l,
                 !.
mycheckdes([H|T]):-
                   H\=l,
                   mycheckdes(T).
mycheckdes([H1,H2|T]):-
                       H1=l,
                       H2=r,
                       mycheckdes(T).
%Is true if the list L of width W and height H has a number of destroyers Tot
check_destroyer([],_,_,_):-!.
check_destroyer(L,W,_,Tot):-
                            list_to_llists(L,W,Tocheck),
                            mycheckforeach(Tocheck),
                            deshelp(L,0,Tot).
%Is true if the list L has a number of destroyers Tot
deshelp([],A,Tot):-
                   A=Tot.
deshelp([F|T],A,Tot):-
                      F=l,
                      A1 is A+1,
                      deshelp(T,A1,Tot).
deshelp([F|T],A,Tot):-
                      F\=l,
                      deshelp(T,A,Tot).
% check_destroyer([],_,_,_).
% check_destroyer([H|T],W,H,Total):-
%                               length([H|T],H),
%                               length(H,W),
%                               flatten([H|T],L),
%                               mycheck([H|T]),
%                               count(L,l,0,Total).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Is true if the first paramater is a grid with width W, height H that has a number of subs TotalSub and a number of destroyers TotalDes where each row has a number of vessels specified in TotalRows and each column has a number of vessels specified in TotalColumns

                                                                                                                                
battleship(L,W,H,TotalSub,TotalDes,[T1|TotalRows],[T2|TotalColumns]):-
                                                                      Size is W*H,
                                                                length(L,Size),
                                                                collect_hints(Hints),
                                                                ensure_hints(L,Hints,W,H),
                                                                      random_assignment(L),
                                                                      check_submarines(L,W,H,TotalSub),
                                                                      check_destroyer(L,W,H,TotalDes),
                                                                      check_rows(L,W,H,[T1|TotalRows]),
                                                                      check_columns(L,W,H,[T2|TotalColumns]).
                                                                      
                                                                      
                                                                                                                                          
                                                                      
                                                                      
                                                                                                                                                                                           
                                                                                                                                          