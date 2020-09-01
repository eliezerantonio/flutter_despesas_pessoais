import 'package:despesas/widgets/adaptative_buttom.dart';
import 'package:despesas/widgets/adaptive_date_picker.dart';
import 'package:flutter/material.dart';

import 'adaptative_text_field.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  TransactionForm(this.onSubmit) {}

  @override
  _TransactionFormState createState() {
    return _TransactionFormState();
  }
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectDate = DateTime.now();

  _TransactionFormState() {}

  @override
  void initState() {
    super.initState();
    print("initState() _transactionFormState");
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget() _transactionFormState");
  }

  void dispose() {
    super.dispose();
    print("dispose() _transactionFormState");
  }

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0 || _selectDate == null) {
      return;
    }
    widget.onSubmit(title, value, _selectDate);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
              top: 10,
              right: 10,
              bottom: 10 +
                  MediaQuery.of(context)
                      .viewInsets
                      .bottom // somando com o tamanho do teclado
              ),
          child: Column(
            children: [
              AdaptativeTextField(
                controller: _titleController,
                label: 'Título',
                onSubmitted: (_) => _submitForm(),
              ),
              AdaptativeTextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _valueController,
                label: 'Valor (KZ)',
                onSubmitted: (_) => _submitForm(),
              ),
              AdaptativeDatePicker(
                selectdDate: _selectDate,
                onDateChanged: (newDate) {
                  setState(() {
                    _selectDate = newDate;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AdaptativeButtom(
                    label: "Nova Transação",
                    onPressed: _submitForm,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
