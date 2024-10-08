type SizeType = "medium" | "small" | "mini"

interface SizeOptionType {
  height: number;
  fontSize: number
}

interface ColorType {
  backgroundColor: ResourceColor
  fontColor: ResourceColor
  borderColor: string
}

interface ColorsType {
  normal: ColorType
  pressed: ColorType
  disabled: ColorType
}

@ComponentV2
struct HiButton {
  /**
   * 组件宽度
   */
  @Local Width: Length = "auto"
  @Param Size: SizeType = "small" // 按钮大小
  @Param text: string = "" // 按钮文字内容
  @Param mode: "primary" | "success" | "warning" | "danger" | "info" | "text" = "primary"
  @Param type: ButtonType = ButtonType.Normal
  @Param radius: Length | BorderRadiuses | LocalizedBorderRadiuses = 4
  @Event onclick: (e?: ClickEvent) => void = () => {
  }

  private getSizeOption() {
    const res: SizeOptionType = { height: 40, fontSize: 18 }
    switch (this.Size) {
      case "medium":
        res.height = 50
        res.fontSize = 22
        break;
      case "mini":
        res.height = 30
        res.fontSize = 14
        break;
    }
    return res
  }

  private getRoundColors(): ColorsType {
    const normal: ColorType = {
      fontColor: "#ffffff",
      backgroundColor: "#409eff",
      borderColor: "#409eff"
    }
    const pressed: ColorType = {
      fontColor: "#ffffff",
      backgroundColor: "#66b1ff",
      borderColor: "#66b1ff"
    }
    const disabled: ColorType = {
      fontColor: "#ffffff",
      backgroundColor: "#a0cfff",
      borderColor: "#a0cfff"
    }

    switch (this.mode) {
      case "success":
        normal.backgroundColor = "#67c23a"
        normal.borderColor = "#67c23a"
        pressed.backgroundColor = "#66b1ff"
        pressed.borderColor = "#66b1ff"
        break;
      case "warning":
        normal.backgroundColor = "#e6a23c"
        normal.borderColor = "#e6a23c"
        pressed.backgroundColor = "#ebb563"
        pressed.borderColor = "#ebb563"
        break;
      case "danger":
        normal.backgroundColor = "#f56c6c"
        normal.borderColor = "#f56c6c"
        pressed.backgroundColor = "#f78989"
        pressed.borderColor = "#f78989"
        break;
      case "info":
        normal.backgroundColor = "#909399"
        normal.borderColor = "#909399"
        pressed.backgroundColor = "#a6a9ad"
        pressed.borderColor = "#a6a9ad"
        break;
      case "text":
        normal.backgroundColor = "#fff"
        normal.borderColor = "#a6a9ad"
        normal.fontColor = "#606266"
        pressed.backgroundColor = "#f9f9f9"
        pressed.borderColor = "#a6a9ad"
        break;
    }


    return { normal, pressed, disabled }
  }

  build() {
    Button(this.text, { type: this.type, stateEffect: true })
      .stateStyles({
        normal: {
          .backgroundColor(this.getRoundColors().normal.backgroundColor)
          .borderColor(this.getRoundColors().normal.borderColor)
        },
        pressed: {
          .backgroundColor(this.getRoundColors().pressed.backgroundColor)
          .borderColor(this.getRoundColors().pressed.borderColor)
        },
        disabled: {
          .backgroundColor(this.getRoundColors().disabled.backgroundColor)
          .borderColor(this.getRoundColors().disabled.borderColor)
        }
      })
      .fontColor(this.getRoundColors().normal.fontColor)
      .borderStyle(BorderStyle.Solid)
      .borderWidth(1)
      .padding({ left: 20, right: 20 })
      .borderRadius(this.radius)
      .height(this.getSizeOption().height)
      .fontSize(this.getSizeOption().fontSize)

      .width(this.Width)
      .onClick(this.onclick)
  }
}


export default HiButton