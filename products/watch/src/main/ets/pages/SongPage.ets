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


import { BusinessError } from '@kit.BasicServicesKit';
import { MediaService, SongItem } from '@ohos/mediaCommon';
import { StyleConstants } from '../constants/StyleConstants';
import { VolumeSlider } from '../components//VolumeSlider'

@Builder
export function SongPageBuilder() {
  SongPage();
}

@Preview
@Entry
@Component
struct SongPage {
  @StorageLink('songList') songList: SongItem[] = [];
  @StorageLink('selectIndex') selectIndex: number = 0;
  @StorageLink('isPlay') isPlay: boolean = false;
  @StorageLink('progress') time: number = 0;
  @StorageLink('progressMax') max: number = 0;

  build() {
    NavDestination() {
      Column() {
        Column() {
          Text(this.songList[this.selectIndex].title)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.font_color'))
          Text(this.songList[this.selectIndex].singer)
            .fontColor($r('app.color.play_singer_color'))
        }

        Row() {
          Column() {
            Image($r('app.media.previous_btn'))
              .width($r('app.float.play_song_img'))
          }
          .onClick(() => {
            MediaService.getInstance().playPrevious()
          })

          Stack() {
            Image(this.songList[this.selectIndex].label)
              .width($r('app.float.play_circle_img'))
              .height($r('app.float.play_circle_img'))
              .borderRadius(StyleConstants.CIRCLE_BORDER_RADIUS)

            Progress({ value: this.time, total: this.max, type: ProgressType.Ring })
              .width($r('app.float.play_progress_width'))
              .backgroundColor(Color.Transparent)
              .color($r('app.color.font_color'))

            Image($r('app.media.play_btn'))
              .width($r('app.float.play_song_img'))
              .visibility(this.isPlay === true ? Visibility.None : Visibility.Visible)
              .onClick(() => {
                if (MediaService.getInstance().getFirst()) {
                  MediaService.getInstance().loadAssent(0);
                } else {
                    this.isPlay ? MediaService.getInstance().pause() : MediaService.getInstance().play();
                }
              })

            Image($r('app.media.pause_btn'))
              .width($r('app.float.play_song_img'))
              .visibility(this.isPlay === true ? Visibility.Visible : Visibility.None)
              .onClick(() => {
                MediaService.getInstance().pause()
              })
          }
          .width(StyleConstants.HALF_WIDTH)
          .align(Alignment.Center)

          Column() {
            Image($r('app.media.next_btn'))
              .width($r('app.float.play_song_img'))
          }
          .onClick(() => {
            MediaService.getInstance().playNextAuto(true)
          })
        }
        .justifyContent(FlexAlign.SpaceAround)
        .width('85%')

        Row() {
          Image($r('app.media.download'))
            .width($r('app.float.play_icon_width'))
          Image($r('app.media.repeat'))
            .width($r('app.float.play_icon_width'))
          Image($r('app.media.full_screen'))
            .width($r('app.float.play_icon_width'))
        }
        .width('60%')
        .justifyContent(FlexAlign.SpaceAround)
      }
      .width(StyleConstants.FULL_WIDTH)
      .height(StyleConstants.FULL_HEIGHT)
      .padding({ top: $r('app.float.play_column_padding'), bottom: $r('app.float.play_column_padding') })
      .justifyContent(FlexAlign.SpaceAround)

      VolumeSlider()
    }
    .hideTitleBar(true)
    .focusable(true)
    .focusOnTouch(true)
    .defaultFocus(true)
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [
        ['#5E4C4B', 1.0],
        ['#695951', 1.0]
      ]
    })
  }
}