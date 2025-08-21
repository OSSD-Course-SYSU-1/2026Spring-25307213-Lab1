/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { LengthMetrics } from '@kit.ArkUI';
import { ArcList, ArcListItem, ArcListAttribute } from '@kit.ArkUI';
import { StyleConstants } from '../constants/StyleConstants';
import { Menu } from '../viewmodel/ViewModel'

@Preview
@Component
export struct Home {
  @Consume pageStack: NavPathStack
  private MenuList: Menu[] = [
    { icon: $r('app.media.hottest_playlists'), text: $r('app.string.home_hottest_playlists'), pathName: 'playList' },
    { icon: $r('app.media.my_favorite'), text: $r('app.string.home_my_favorite'), pathName: 'songList' },
    { icon: $r('app.media.is_playing'), text: $r('app.string.home_is_playing'), pathName: 'songPage' },
    { icon: $r('app.media.setting'), text: $r('app.string.home_setting'), pathName: 'setting' }
  ]

  build() {
    Column() {
      ArcList({ initialIndex: 0 }) {
        ForEach(this.MenuList, (item: Menu) => {
          ArcListItem() {
            Row() {
              Image(item.icon)
                .width($r('app.float.home_icon_width'))
                .height($r('app.float.home_icon_width'))
                .borderRadius(StyleConstants.CIRCLE_BORDER_RADIUS)
                .backgroundColor($r('app.color.home_icon_background'))
                .padding($r('app.float.home_icon_padding'))

              Text(item.text)
                .fontColor($r('app.color.font_color'))
                .fontSize($r('app.float.home_font_size'))
              Image($r('app.media.chevron_right'))
                .width($r('app.float.home_icon_jump_width'))
            }
            .width(StyleConstants.HOME_BTN_WIDTH)
            .height($r('app.float.home_btn_height'))
            .padding({ left: $r('app.float.list_btn_padding'), right: $r('app.float.list_btn_padding') })
            .justifyContent(FlexAlign.SpaceBetween)
            .borderRadius(StyleConstants.CIRCLE_BORDER_RADIUS)
            .focusable(true)
            .focusOnTouch(true)
            .backgroundColor($r('app.color.home_btn_background'))
            .onClick(() => {
              if (item.pathName === 'setting') {
                return
              }
              this.pageStack.replacePathByName(item.pathName, null);
            })
          }
        },
          (item: Menu, index: number) => (item).toString() + index)
      }
      .scrollBar(BarState.Off)
      .space(LengthMetrics.vp(5))
      .borderRadius(StyleConstants.CIRCLE_BORDER_RADIUS)
      .focusable(true)
      .focusOnTouch(true)
      .defaultFocus(true)
    }
    .align(Alignment.Center)
    .width(StyleConstants.FULL_WIDTH)
    .height(StyleConstants.FULL_HEIGHT)
    .borderRadius(StyleConstants.CIRCLE_BORDER_RADIUS)
  }
}