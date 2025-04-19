
export function showTopToast(uiContext: UIContext, msg: string) {
  uiContext.getPromptAction().showToast({
    message: msg,
    duration: 1000,
    alignment: Alignment.Top,
    shadow: ShadowStyle.OUTER_FLOATING_SM
  })
}
export function showBottomError(uiContext: UIContext, msg: string, duration?: number) {
  showBottomToast(uiContext, msg, Color.Red, duration)
}
export function showBottomToast(uiContext: UIContext, msg: string, textColor?: Color, duration?: number) {
  uiContext.getPromptAction().showToast({
    message: msg,
    duration: duration? duration : 2000,
    alignment: Alignment.Bottom,
    shadow: ShadowStyle.OUTER_FLOATING_SM,
    textColor: textColor? textColor : Color.Black
  })
}