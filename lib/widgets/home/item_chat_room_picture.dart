import 'package:flutter/material.dart';
import 'package:self_talk/utils/Constants.dart';
import 'package:self_talk/widgets/common/profile_picture.dart';


class ThreePeoplePicture extends StatelessWidget {
  /// 단톡방에 3명(자신 포함)일 때 사용
  const ThreePeoplePicture({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedOverflowBox(
      size: const Size(profileImgWidth,profileImgHeight),
      child: Transform.scale(
        scale: 0.6682,
        child: Stack(
          children: [
            // 배경
            Container(
              alignment: Alignment.topCenter,
              width: profileImgWidth + profileImgWidth / 2,
              height: profileImgHeight + profileImgHeight / 2,
              child: ProfilePicture(),
            ),
            // 겹친 항목
            const Positioned(
              top: profileImgHeight - profileImgHeight / 2,
              left: profileImgWidth - profileImgWidth / 2,
              child: ProfilePicture(),
            ),
          ],
        ),
      ),
    );
  }
}

class FourGroupPeople extends StatelessWidget {
  /// 단톡방에 4명(자신 포함)일 때 사용
  const FourGroupPeople({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedOverflowBox(
      size: const Size(profileImgWidth,profileImgHeight),
      child: Transform.scale(
        scale: 0.5,
        child: Container(
          width: profileImgWidth*2,
          height: profileImgHeight*2,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            children: [
              ProfilePicture(),
              ProfilePicture(),
              ProfilePicture(),
              Container(
                child: Text("#123"),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class MultiGroupPeople extends StatelessWidget {
  /// 단톡방에 5명(자신 포함)이상 일 때 사용
  const MultiGroupPeople({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedOverflowBox(
      size: const Size(profileImgWidth,profileImgHeight),
      child: Transform.scale(
        scale: 0.5,
        child: Container(
          width: profileImgWidth*2,
          height: profileImgHeight*2,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            children: [
              ProfilePicture(),
              ProfilePicture(),
              ProfilePicture(),
              ProfilePicture(),
            ],
          ),
        ),
      ),
    );
  }
}
