# no module name: this is an anonymous module

function getMain = |args...| {
  println("getMain called")
  
  return DynamicObject()
    : define("roll", |this| {

        this: publish("hello",
          JSON.stringify(DynamicObject()
            : colorIndex(this: rnd(0,1))
            : speed(this: rnd(0,90))
            : direction(this: rnd(0,360))
          )
        )

      }) # end of roll

}