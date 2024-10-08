# Signature
`一款为鸿蒙系统设计的基于Canvas的手写签名组件，支持多种配置选项和事件监听功能。`
## 安装
```shell
ohpm i hi-signature
```
## 属性
| 属性名 | 说明       | 类型       | 默认值       | 可选值                                   |
| ---   |----------|----------|-----------|---------------------------------------|
| `Width`   | 画布宽度     | `Length`   | `100%`      | -                                     |
| `Height`   | 画布高度     | `Length`   | `100%`      | -                                     |
| `BackgroundColor`   | 画布（图片）背景 | `string`   | `none`      | -                                     |
| `LineWidth`   | 画笔宽度     | `number`   | `3`         | -                                     |
| `StrokeColor`   | 画笔颜色     | `string`   | `#000000`   | -                                     |
| `Type`   | 图片类型     | `ImageType` | `image/png` | `image/png` `image/jpeg` `image/webp` |

## 方法
| 方法名 | 说明    | 参数                   |
|-----|-------|----------------------|
|`back`| 回退笔画  | -                    |
|`clear`| 清除画布  | -                    |
|`toDataUrl`| 生成图片URL  | `(url:string)=>void` |

## 事件
| 事件名 | 说明 | 参数                      |
|----|----|-------------------------|
| `onReady`   |组件构造结束| `(e:HiSignature)=>void` |
| `start`   |笔画开始| -                       |
| `signing`   |签名中| -                       |
| `end`   |笔画结束| -                       |



## 使用示例
```ets
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
```
### 效果预览
![示例图片](https://image.whzb.com/chain/StellarUI/image/demo.png "示例图片说明")
