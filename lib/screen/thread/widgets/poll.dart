import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:percent_indicator/percent_indicator.dart';

typedef PollCallback = void Function();

class Poll extends StatefulWidget {
  final String tid;
  final SpecialPoll poll;
  final PollCallback? callback;

  const Poll({
    super.key,
    required this.tid,
    required this.poll,
    this.callback,
  });

  @override
  State<StatefulWidget> createState() => _PollState();
}

class _PollState extends State<Poll> {
  final List<String> pollAnswers = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    final pollTitle = Row(
      children: [
        widget.poll.multiple == '1'
            ? const Text(
                '多选投票：',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            : const Text(
                '单选投票，',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        if (widget.poll.multiple == '1')
          Text('最多可选${widget.poll.maxChoices}项，'),
        Text('共有 ${widget.poll.votersCount} 人参与投票')
      ],
    );
    children.add(pollTitle);
    var index = 1;
    for (final pollOption in widget.poll.pollOptions) {
      final indexStr = '$index.';
      final title = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(indexStr),
          Flexible(
            child: Text(pollOption.pollOption),
          ),
          Text(
            ' ${pollOption.percent.toString()}%',
          ),
          Text(
            '(${pollOption.votes.toString()})',
            style: TextStyle(
                color: Color(int.parse('ff${pollOption.color}', radix: 16))),
          ),
        ],
      );

      final leading = widget.poll.allowVote
          ? Checkbox(
              value: pollAnswers.contains(pollOption.pollOptionId),
              onChanged: (value) {
                if (value!) {
                  if (!pollAnswers.contains(pollOption.pollOptionId)) {
                    pollAnswers.add(pollOption.pollOptionId);
                  }
                } else {
                  pollAnswers.remove(pollOption.pollOptionId);
                }
                setState(() {});
              },
            )
          : null;
      final linearPercent = LinearPercentIndicator(
        width: MediaQuery.of(context).size.width - 100.0,
        lineHeight: 24.0,
        animation: true,
        animationDuration: 1000,
        percent: pollOption.percent / 100,
        backgroundColor: Colors.transparent,
        progressColor: Color(int.parse('ff${pollOption.color}', radix: 16)),
        leading: leading,
      );
      children.add(title);
      children.add(linearPercent);
      index++;
    }

    if (widget.poll.allowVote) {
      children.add(Row(children: [
        ElevatedButton(
          child: const Text('投票'),
          onPressed: () async {
            if (pollAnswers.isNotEmpty) {
              context
                  .read<Keylol>()
                  .pollVote(widget.tid, pollAnswers)
                  .then((value) => widget.callback?.call());
            }
          },
        ),
        Expanded(child: Container())
      ]));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: children,
      ),
    );
  }
}
