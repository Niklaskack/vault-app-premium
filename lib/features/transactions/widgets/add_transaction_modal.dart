import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/repositories/transaction_repository.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/providers/service_providers.dart';
import '../../../services/ocr_service.dart';
import '../../../services/voice_service.dart';
import '../../../services/nlp_service.dart';
import '../../../core/l10n/app_localizations.dart';

class AddTransactionModal extends ConsumerStatefulWidget {
  const AddTransactionModal({super.key});

  @override
  ConsumerState<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends ConsumerState<AddTransactionModal> {
  final _formKey = GlobalKey<FormState>();
  final _merchantController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TransactionCategory _category = TransactionCategory.other;
  TransactionType _type = TransactionType.expense;

  bool _isListening = false;
  String _voiceText = '';

  Future<void> _startVoiceEntry() async {
    final voiceService = ref.read(voiceServiceProvider);
    final isAvailable = await voiceService.init();
    
    if (isAvailable) {
      setState(() => _isListening = true);
      voiceService.startListening((text) {
        setState(() => _voiceText = text);
      });

      // Auto-stop after 5 seconds of silence or manual stop
      Future.delayed(const Duration(seconds: 5), () {
        if (_isListening) _stopVoiceEntry();
      });
    }
  }

  void _stopVoiceEntry() {
    final voiceService = ref.read(voiceServiceProvider);
    voiceService.stopListening();
    setState(() => _isListening = false);

    if (_voiceText.isNotEmpty) {
      final nlpService = ref.read(nlpServiceProvider);
      final transaction = nlpService.parseSentence(_voiceText);
      
      if (transaction != null) {
        setState(() {
          _merchantController.text = transaction.merchant;
          _amountController.text = transaction.amount.toStringAsFixed(2);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Heard: "$_voiceText"')),
        );
      }
    }
  }

  Future<void> _scanReceipt() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    
    if (image == null) return;

    // Show loading
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scanning receipt...')),
    );

    try {
      final ocrService = ref.read(ocrServiceProvider);
      final data = await ocrService.scanImage(image.path);
      
      if (data != null && mounted) {
        setState(() {
          _merchantController.text = data.merchant;
          _amountController.text = data.amount.toStringAsFixed(2);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receipt details extracted!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to read receipt: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.watch(l10nProvider);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('New Transaction', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 16),
            SegmentedButton<TransactionType>(
              segments: const [
                ButtonSegment(value: TransactionType.expense, label: Text('Expense'), icon: Icon(Icons.remove_circle_outline)),
                ButtonSegment(value: TransactionType.income, label: Text('Income'), icon: Icon(Icons.add_circle_outline)),
              ],
              selected: {_type},
              onSelectionChanged: (Set<TransactionType> newSelection) {
                setState(() => _type = newSelection.first);
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _merchantController,
                    decoration: const InputDecoration(
                      labelText: 'Merchant',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.store),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Please enter merchant' : null,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.outlined(
                  onPressed: _scanReceipt,
                  icon: const Icon(Icons.camera_alt_outlined),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.payments_outlined),
                suffixText: l10n.translate('currency_symbol'),
              ),
              keyboardType: TextInputType.number,
              validator: (val) => val == null || double.tryParse(val) == null ? 'Please enter valid amount' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
                  ),
                ),
                const SizedBox(width: 12),
                Animate(
                  target: _isListening ? 1 : 0,
                  effects: [ShimmerEffect(duration: const Duration(seconds: 1))],
                  child: IconButton(
                    onPressed: _isListening ? _stopVoiceEntry : _startVoiceEntry,
                    icon: Icon(_isListening ? Icons.stop : Icons.mic),
                    style: IconButton.styleFrom(
                      backgroundColor: _isListening ? Colors.red.shade100 : Colors.blue.shade50,
                    ),
                    iconSize: _isListening ? 28 : 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Transaction', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final tx = Transaction(
        merchant: _merchantController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        type: _type,
        category: _category,
      );
      
      await ref.read(transactionRepositoryProvider).addTransaction(tx);
      ref.invalidate(transactionsProvider);
      
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction added successfully!')),
      );
    }
  }
}
