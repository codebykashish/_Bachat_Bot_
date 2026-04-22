import 'package:flutter/material.dart';

class FoodDiningScreen extends StatefulWidget {
  const FoodDiningScreen({super.key});

  @override
  State<FoodDiningScreen> createState() => _FoodDiningScreenState();
}

class _FoodDiningScreenState extends State<FoodDiningScreen> {
  final _noteController = TextEditingController();
  String _amount = '0';
  bool _reminderEnabled = true;

  static const Color _teal = Color(0xFF2BBDA4);

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _onKeyPress(String key) {
    setState(() {
      if (key == 'C') {
        _amount = '0';
      } else if (key == '.') {
        if (!_amount.contains('.')) _amount += '.';
      } else if (['+', '-', '×', '÷'].contains(key)) {
        // basic operator handling
      } else {
        if (_amount == '0') {
          _amount = key;
        } else {
          _amount += key;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Food & Dining', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(icon: const Icon(Icons.person_outline, color: Colors.black87), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Spending Reminder
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.notifications_outlined, color: _teal, size: 22),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Spending Reminder', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            Text('Alert when over budget', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Switch(
                        value: _reminderEnabled,
                        onChanged: (v) => setState(() => _reminderEnabled = v),
                        activeColor: _teal,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Daily at 8:00 PM', style: TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(width: 12),
                      Text('Threshold: \$50.00', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Amount to log
            Text('AMOUNT TO LOG', style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.credit_card_outlined, color: _teal, size: 22),
                  const SizedBox(width: 8),
                  const Text('\$ ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black)),
                  Text(_amount, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('ADD A NOTE', style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Dinner at Olive Garden...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _teal),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add Expense', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('QUICK CALCULATOR', style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
            const SizedBox(height: 10),
            _buildCalculator(),
            const SizedBox(height: 20),
            _buildMenuRow(Icons.radio_button_checked_outlined, 'Set Monthly Budget', '\$400.00 left', _teal),
            const SizedBox(height: 4),
            _buildMenuRow(Icons.history_outlined, 'View Transaction History', '', Colors.orange),
            const SizedBox(height: 4),
            _buildMenuRow(Icons.edit_outlined, 'Edit Category Style', '', Colors.green),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F9F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: _teal, size: 18),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Tip: You spent 12% more on Food this month compared to March. Try setting a budget alert!',
                      style: TextStyle(fontSize: 12, color: _teal),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: _teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }

  Widget _buildCalculator() {
    final rows = [
      ['7', '8', '9', '+'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '×'],
      ['C', '0', '.', '÷'],
    ];
    return Column(
      children: rows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: row.map((key) {
              final isSpecial = ['C', '+', '-', '×', '÷'].contains(key);
              final isC = key == 'C';
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => _onKeyPress(key),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: isC ? const Color(0xFFE6F9F5) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        key,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: isSpecial ? _teal : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMenuRow(IconData icon, String label, String trailing, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          if (trailing.isNotEmpty)
            Text(trailing, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
        ],
      ),
    );
  }
}