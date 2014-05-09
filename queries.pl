%hsql(FROM,WHERE,SELECT)

%Retrieval
hsql1( [whatulike::interests as b],
       [b::nickname='Bob'],
       [b::nickname, b::interests] 
     ).

%Projection
hsql2_1([whatulike::interests as b],
      [b::nickname ='Bob'],
      [b::interests::interest::nickname,
       b::interests::interest::tag]
     ).

hsql2_2([whatulike::interests as a,
       whatulike::interests as b],
      [a::nickname='Alice',
       b::nickname='Bob',
       a::interests::interest::tag=b::interests::interest::tag],
      [ b::nickname, b::interests]
     ).

%Filtering
hsql3([whatulike::interests as b],
      [b::nickname='Bob',
       b::interests::interest::tag='Art History'],
      [b::nickname,
       b::interests]
     ).

%Correlation
hsql4_1([whatulike::interests as a,
       whatulike::interests as b],
      [a::nickname='Alice',
       b::nickname='Bob',
       a::interests::interest::tag=b::interests::interest::tag],
      [a::nickname, a::interests, 
       b::nickname, b::interests]
     ).

hsql4_1_2([whatulike::interests as a,
       whatulike::interests as b],
      [a::nickname='Alice',
       b::nickname='Bob',
       a::interests::interest::tag=b::interests::interest::tag],
      [a::nickname,
       b::nickname, b::interests]
     ).

hsql4_2([whatulike::interests as a,
       whatulike::interests as b],
      [a::nickname='Alice',
       b::nickname='Bob',
       a::interests::interest::tag=b::interests::interest::tag,
       a::interests::interest::score=b::interests::interest::score],
      [a::nickname, a::interests, 
       b::nickname, b::interests]
     ).

hsql4_3([whatulike::interests as a,
	 whatulike::interests as b],
	[a::nickname='Alice',
	b::nickname='Bob',
	a::interests::interest::tag=b::interests::interest::tag,
	a::interests::interest::tag ='Art History'],
	[a::nickname, a::interests,
	b::nickname, b::interests]
      ).

hsql4_4([whatulike::interests as a,
	 whatulike::interests as b],
	[a::nickname='Alice',
	b::nickname='Bob',
	a::interests::interest::tag=b::interests::interest::tag,
	a::interests::interest::tag ='Art History'],
	[a::nickname,
	 b::nickname,
         a::interests::interest::tag]
      ).

hsql4_5([whatulike::interests as a,
	 whatulike::interests as b],
	[a::nickname='Alice',
	b::nickname='Bob',
	a::interests::interest::tag=b::interests::interest::tag,
	a::interests::interest::tag ='Art History',
	a::interests::interest::score ='0.98',
	b::interests::interest::tag ='Art History',
	b::interests::interest::score ='0.98'],
	[a::nickname,
	 b::nickname,
         a::interests::interest::tag]
      ).

%Binding
hsql5_1([friends::friendsof  as f,
       whatulike::interests as i],
      [f::nickname='Alice',
       i::nickname=f::friendship::with::friend],
      [i::nickname, i::interests,f::friendship::with::friend]
     ).

hsql5_2( [friends::friendsof as a,
          friends::friendsof as b,
          whatulike::interests as i],
         [a::nickname = 'Alice', %retrieval
          b::nickname = 'Bob' , %retrieval
          a::friendship::with::friend = b::friendship::with::friend, %correlation
          i::nickname = a::friendship::with::friend,  %binding
          i::interests::interest::tag ='Art History'], %filtering
         [a::nickname, %projection
          b::nickname, %projection
          a::friendship::with::friend,
	  i::interests::interest::tag] %projection
	).
