import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiaryModal extends StatefulWidget {
  final DateTime date;
  final String? initialNote;
  final void Function(String note) onSave;
  final VoidCallback onDelete;

  const DiaryModal({
    required this.date,
    this.initialNote,
    required this.onSave,
    required this.onDelete,
  });

  @override
  _DiaryModalState createState() => _DiaryModalState();
}

class _DiaryModalState extends State<DiaryModal> {
  late TextEditingController _noteController;
  bool _isSaved = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    try {
      setState(() {
        _isSaved = true;
        _isEditing = false;
      });
      widget.onSave(_noteController.text);
      Navigator.of(context).pop();
    } catch (e) {
      print('Failed to save diary entry: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('다이어리 저장 실패')),
      );
    }
  }

  void _resetState() {
    setState(() {
      _isSaved = false;
      _isEditing = true;
      _noteController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final borderColor = theme.colorScheme.onSurface.withOpacity(0.2);

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75, // 화면의 85% 높이로 설정
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${DateFormat('d ').format(widget.date)} ${DateFormat('EEEE').format(widget.date)}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _noteController,
                  cursorColor: theme.colorScheme.primary,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '오늘 하루의 은혜를 담아보세요 💚',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
                  maxLines: null,
                  enabled: _isEditing || (_noteController.text.isEmpty),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _isEditing ? _resetState : widget.onDelete,
                    child: Text(
                      _isEditing ? '초기화' : '삭제',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _save,
                    child: const Text('저장'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
