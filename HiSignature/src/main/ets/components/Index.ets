interface Stroke {
  x: number
  y: number
}

interface SignArea extends Area{
  initialize:boolean
}

type ImageType = "image/png" | "image/jpeg" | "image/webp"

@ComponentV2
struct HiSignature{
  @Param Width:Length = "100%"
  @Param Height:Length = "100%"
  @Param BackgroundColor:string = "none"
  @Param LineWidth:number = 3
  @Param StrokeColor:string = "#000"
  @Param Type:ImageType="image/png"


  @Event start:()=>void=()=>{}
  @Event signing:()=>void=()=>{}
  @Event end:()=>void=()=>{}
  @Event onReady:(e?:HiSignature)=>void=()=>{}

  //用来配置CanvasRenderingContext2D对象的参数，包括是否开启抗锯齿，true表明开启抗锯齿。
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  //用来创建CanvasRenderingContext2D对象，通过在canvas中调用CanvasRenderingContext2D对象来绘制。
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  private strokes:Stroke[][]=[]
  private strokeing:Stroke[]=[]

  private area:SignArea ={
    position:{x:0,y:0},
    globalPosition:{x:0,y:0},
    width:3000,
    height:3000,
    initialize:false
  }

  private drawStrokes(ctx:OffscreenCanvasRenderingContext2D | CanvasRenderingContext2D = this.context){
    const width = Number(this.area.width);
    const height = Number(this.area.height);
    ctx.lineCap = "round"
    ctx.lineWidth = this.LineWidth
    ctx.strokeStyle = this.StrokeColor
    ctx.lineJoin = "round"
    ctx.clearRect(0,0,width,height)
    if(this.BackgroundColor !== "none") {
      ctx.fillStyle = this.BackgroundColor
      ctx.fillRect(0, 0, width, height)
    }
    if(!this.strokes.length) return;
    const path2D = new Path2D()
    this.strokes.forEach((m)=>{
      if(!m.length) return
      const start = m[0]
      path2D.moveTo(start.x,start.y)
      m.forEach((s,i)=>{
        if(i === 0) return;
        path2D.lineTo(s.x,s.y)
      })
    })
    ctx.stroke(path2D)
  }

  private  drawStrokeing(){
    const length = this.strokeing.length
    if(!length) return
    const ctx = this.context
    ctx.beginPath()
    const end = this.strokeing[length - 1]
    const start = this.strokeing[length - 2] || end
    ctx.moveTo(start.x,start.y)
    ctx.lineTo(end.x,end.y)
    ctx.stroke()
  }

  public clear(){
    this.strokes = [];
    this.drawStrokes()
  }

  public back(){
    this.strokes.pop()
    this.drawStrokes()
  }

  public toDataUrl(callback:(url?:string)=>void){
    if(!this.strokes.length){
      return callback()
    }
    const width = Number(this.area.width);
    const height = Number(this.area.height);
    const offCanvas = new OffscreenCanvas(width,height)
    const offContext = offCanvas.getContext("2d",this.settings)
    this.drawStrokes(offContext)
    const imageData = offContext.toDataURL(this.Type)
    callback(imageData)
  }


  build() {
    Canvas(this.context).width(this.Width).height(this.Height).onReady(()=>{
      this.drawStrokes()
      this.onReady(this)
    }).onTouch((e)=>{
      if(!this.area.initialize){
        const area = e.target.area
        this.area.position = area.position
        this.area.globalPosition = area.globalPosition
        this.area.width = area.width
        this.area.height = area.height
        this.area.initialize = true
      }
      const info = e.touches[0]
      switch (e.type){
        case TouchType.Down:
          this.strokeing = [{x:info.x,y:info.y}]
          this.drawStrokeing()
          this.start()
          break
        case TouchType.Move:
          this.strokeing.push({x:info.x,y:info.y})
          this.drawStrokeing()
          this.signing()
          break
        case TouchType.Up:
          this.strokes.push(this.strokeing)
          this.strokeing = []
          this.end()
          break
      }
    })
  }
}



export default  HiSignature