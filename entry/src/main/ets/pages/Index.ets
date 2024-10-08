import HiSignature from "hi-signature"

@Entry
@ComponentV2
struct Index {
  @Local message: string = 'Hello World';
  @Local signature?:HiSignature
  @Local imgUrl?:string

  build() {
    Column(){
      Scroll(){
        Column(){
          Row(){
            HiSignature({
              Width:"100%",
              Height:250,
              BackgroundColor:"#f5f5f5",
              onReady:(e)=>{
                this.signature = e
              }
            })
          }

          Row(){
            Column(){
              Button("退回").onClick(()=>{
                this.signature?.back()
              })
            }
            Column(){
              Button("清空").onClick(()=>{
                this.signature?.clear()
              })
            }.margin({left:10})
            Column(){
              Button("生成图片").onClick(()=>{
                this.signature?.toDataUrl((url)=>{
                  if(!url){
                    console.log("未绘制签名")
                    return
                  }
                  this.imgUrl = url
                })
              })
            }.margin({left:10})
          }.margin({top:10,bottom:10})

          Text("预览图片")
          Image(this.imgUrl)
        }
      }
    }
  }
}