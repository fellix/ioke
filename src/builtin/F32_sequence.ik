Sequence mimic!(Mixins Enumerable)

Sequence each = dmacro(
  [chain]
  while(next?,
    chain evaluateOn(call ground, next)
  )
  @,

  [argumentName, code]
  lexicalCode = LexicalBlock createFrom(list(argumentName, code), call ground)
  while(next?,
    lexicalCode call(next)
  )
  @,

  [indexArgumentName, argumentName, code]
  lexicalCode = LexicalBlock createFrom(list(indexArgumentName, argumentName, code), call ground)
  index = 0
  while(next?,
    lexicalCode call(index, next)
    index++
  )
  @
)

Mixins Sequenced each = dmacro(
  []
  seq,

  [chain]
  s = seq
  while(s next?,
    chain evaluateOn(call ground, s next)
  )
  @,

  [argumentName, code]
  s = seq
  lexicalCode = LexicalBlock createFrom(list(argumentName, code), call ground)
  while(s next?,
    lexicalCode call(s next)
  )
  @,

  [indexArgumentName, argumentName, code]
  s = seq
  lexicalCode = LexicalBlock createFrom(list(indexArgumentName, argumentName, code), call ground)
  index = 0
  while(s next?,
    lexicalCode call(index, s next)
    index++
  )
  @
)


Mixins Sequenced do(
  mapped = macro(call resendToReceiver(self seq))
  collected = macro(call resendToReceiver(self seq))
  filtered = macro(call resendToReceiver(self seq))
  selected = macro(call resendToReceiver(self seq))
  grepped = macro(call resendToReceiver(self seq))
  zipped = macro(call resendToReceiver(self seq))
  dropped = macro(call resendToReceiver(self seq))
  droppedWhile = macro(call resendToReceiver(self seq))
  rejected = macro(call resendToReceiver(self seq))
  indexed = macro(call resendToReceiver(self seq))
  interpose = macro(call resendToReceiver(self seq))
  interleave = macro(call resendToReceiver(self seq))
  consed = macro(call resendToReceiver(self seq))
  sliced = macro(call resendToReceiver(self seq))
)

Sequence mapped       = macro(Sequence Map create(@, call ground, call arguments))
Sequence collected    = macro(Sequence Map create(@, call ground, call arguments))
Sequence filtered     = macro(Sequence Filter create(@, call ground, call arguments))
Sequence selected     = macro(Sequence Filter create(@, call ground, call arguments))
Sequence grepped      = dmacro(
  [>toGrepAgainst]
  Sequence Grep create(@, Ground, [], toGrepAgainst),

  [>toGrepAgainst, argName, theCode]
  Sequence Grep create(@, call ground, [argName, theCode], toGrepAgainst)
)
Sequence rejected     = macro(Sequence Reject create(@, call ground, call arguments))
Sequence zipped       = method(+toZipAgainst, Sequence Zip create(@, Ground, [], *toZipAgainst))
Sequence dropped      = method(howManyToDrop, Sequence Drop create(@, Ground, [], howManyToDrop))
Sequence droppedWhile = macro(Sequence DropWhile create(@, call ground, call arguments))
Sequence indexed      = method(from: 0, step: 1, Sequence Index create(@, Ground, [], from, step))
Sequence +            = method(other, Sequence Combination create(@, other))
Sequence interpose    = method(inbetween, Sequence Interpose create(@, inbetween))
Sequence cell("%")    = method(inbetween, Sequence Interpose create(@, inbetween))
Sequence interleave   = method(right, Sequence Interleave create(@, right))
Sequence cell("&")    = method(right, Sequence Interleave create(@, right))
Sequence consed       = method(consSize 2, Sequence Cons create(@, Ground, [], consSize))
Sequence sliced       = method(sliceSize 2, Sequence Slice create(@, Ground, [], sliceSize))

let(
  generateNextPMethod, method(takeCurrentObject, returnObject,
    ''method(
      if(@current?,
        true,
        while(@wrappedSequence next?,
          n = @wrappedSequence next
          x = transformValue(cell(:n))
          if(`takeCurrentObject,
            @current? = true
            @current = `returnObject
            return(true)
          )
        )
        false)
      ) evaluateOn(@)
    ),

  generateNextMethod, method(takeCurrentObject, returnObject,
    ''method(
      if(@current?,
        @current? = false
        @ cell(:current),
        while(@wrappedSequence next?,
          n = @wrappedSequence next
          x = transformValue(cell(:n))
          if(`takeCurrentObject,
            return(`returnObject)))
      )
    ) evaluateOn(@)
    ),

  sequenceObject, dmacro(
    [takeCurrentObject, returnObject]
    s = Sequence Base mimic
    s next? = generateNextPMethod(takeCurrentObject, returnObject)
    s next  = generateNextMethod(takeCurrentObject, returnObject)
    s
    ),

  Sequence Base   = Sequence mimic do(current? = false)
  Sequence Base create = method(wrappedSequence, context, messages, +rest,
    res = mimic
    res wrappedSequence = wrappedSequence
    res context = context
    res messages = messages
    res restArguments = rest
    if(messages length == 2,
      res destructor = Mixins Enumerable Destructor from(messages[0])
      res lexicalBlock = LexicalBlock createFrom(res destructor argNames + list(messages[1]), context)
    )
    res
  )

  Sequence Base transformValue = method(inputValue,
    if(messages length == 0,
      cell(:inputValue),
      if(messages length == 1,
        messages[0] evaluateOn(context, cell(:inputValue)),
        lexicalBlock call(*(destructor unpack(cell(:inputValue)))))
    )
  )

  Sequence Map       = sequenceObject(true,     cell(:x))
  Sequence Filter    = sequenceObject(cell(:x), cell(:n))
  Sequence Reject    = sequenceObject(!cell(:x), cell(:n))
  Sequence Grep      = sequenceObject(restArguments[0] === cell(:n), cell(:x))
  Sequence Drop      = sequenceObject(if(restArguments[0] == 0, true, restArguments[0] = restArguments[0] - 1. false), cell(:n))
  Sequence DropWhile = sequenceObject(
    unless(@collecting,
      unless(cell(:x),
        @collecting = true,
        false),
      true),
    cell(:n)) do(collecting = false)

  Sequence Zip       = sequenceObject(true,
    resultList = list(cell(:n))
    restArguments each(rr,
      resultList << if(rr next?, rr next, nil))
    resultList
  ) do(
    baseCreate = Sequence Base cell(:create)
    create = method(+args,
      myNewSelf = baseCreate(*args)
      myNewSelf restArguments map!(x,
        if(x mimics?(Sequence),
          x,
          x seq)
      )
      myNewSelf
    )
  )

  Sequence Cons      = Sequence mimic do(
    create = method(wrappedSequence, context, messages, +rest,
      res = mimic
      res wrappedSequence = wrappedSequence
      res context = context
      res messages = messages
      res restArguments = rest
      res ary = list()
      res
    )

    next? = method(
      while((ary length + 2 < restArguments[0]) && wrappedSequence next?,
        ary push!(wrappedSequence next))
      ((ary length + 2) >= restArguments[0]) && wrappedSequence next?
    )

    next = method(
      while(wrappedSequence next?,
        if(ary length == restArguments[0],
          ary shift!)
        ary push!(wrappedSequence next)
        if(ary length == restArguments[0],
          return(ary mimic)))
    )
  )

  Sequence Slice      = Sequence mimic do(
    create = method(wrappedSequence, context, messages, +rest,
      res = mimic
      res wrappedSequence = wrappedSequence
      res context = context
      res messages = messages
      res restArguments = rest
      res ary = list()
      res
    )

    next? = method(wrappedSequence next? || ary length > 0)

    next = method(
      while(wrappedSequence next?,
        ary push!(wrappedSequence next)
        if(ary length == restArguments[0],
          yieldAry = ary mimic
          @ary = list()
          return(yieldAry)))
      if(ary length > 0, ary)
    )
  )

  Sequence Index       = sequenceObject(true,
    result = list(@index, cell(:n))
    @index = @index + @step
    result
  ) do(
    baseCreate = Sequence Base cell(:create)
    create = method(+args,
      myNewSelf = baseCreate(*args)
      myNewSelf index = myNewSelf restArguments[0]
      myNewSelf step = myNewSelf restArguments[1]
      myNewSelf
    )
  )

  Sequence Combination = Sequence mimic do(
    create = method(left, right,
      newObj = mimic
      newObj current = left
      newObj right? = true
      newObj right = right
      newObj
    )

    next = method(
      if(current next?,
        current next,
        if(right?,
          @current = right
          @right? = false
          current next,
          nil))
    )

    next? = method(
      current next? || (right? && right next?)
    )
  )

  Sequence Interpose = Sequence mimic do(
    create = method(realSeq, inbetween,
      newObj = mimic
      newObj realSeq = realSeq
      newObj inbetween = inbetween
      newObj takeInbetween = false
      newObj
    )

    next = method(
      if(takeInbetween,
        @takeInbetween = false
        inbetween,
        @takeInbetween = true
        realSeq next)
    )

    next? = method(
      realSeq next?
    )
  )

  Sequence Interleave = Sequence mimic do(
    create = method(left, right,
      newObj = mimic
      newObj left = left
      newObj right = if(right mimics?(Sequence), right, right seq)
      newObj left? = true
      newObj
    )

    next = method(
      if(left?,
        @left? = false
        left next,
        @left? = true
        right next)
    )

    next? = method(
      leftNext? = left next?
      rightNext? = right next?
      (leftNext? && rightNext?) || (!left? && rightNext?)
    )
  )
)

Sequence infinity = method(
  "Returns a new sequence that starts from zero and steps forever",
  from: 0, step: 1,
  fn(n, [n + step]) iterate(from) mapped(first))

Sequence ℕ = method(
  "Returns a new sequence of all the natural numbers",
  fn(n, [n + 1]) iterate(0) mapped(first))

Sequence ω = method(
  "Returns a new sequence of all the natural numbers",
  fn(n, [n + 1]) iterate(0) mapped(first))

