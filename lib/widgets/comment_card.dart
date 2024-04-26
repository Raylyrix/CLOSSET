import 'package:CLOSSET/models/comment.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  Comment comment;
  CommentCard({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          comment.userImage != ""
              ? CircleAvatar(
                  backgroundImage: NetworkImage(comment.userImage),
                  radius: 18,
                )
              : const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 18,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: comment.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                          text: ' ${comment.content}',
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      "21/2/4ds",
                      // DateFormat('yyyy-MM-dd').format(comment.),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.favorite,
              size: 16,
            ),
          )
        ],
      ),
    );
  }
}
