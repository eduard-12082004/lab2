import 'package:flutter/material.dart';

class CitySelectorWidget extends StatefulWidget {
  final bool useCustomCity;
  final String selectedCity;
  final TextEditingController cityController;
  final List<String> cities;
  final Function(bool) onModeChanged;
  final Function(String?) onCitySelected;
  final VoidCallback onSearchPressed;

  const CitySelectorWidget({
    super.key,
    required this.useCustomCity,
    required this.selectedCity,
    required this.cityController,
    required this.cities,
    required this.onModeChanged,
    required this.onCitySelected,
    required this.onSearchPressed,
  });

  @override
  State<CitySelectorWidget> createState() => _CitySelectorWidgetState();
}

class _CitySelectorWidgetState extends State<CitySelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Выбрать из списка'),
                    selected: !widget.useCustomCity,
                    onSelected: (selected) {
                      widget.onModeChanged(!selected);
                    },
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color:
                          !widget.useCustomCity ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Ввести вручную'),
                    selected: widget.useCustomCity,
                    onSelected: (selected) {
                      widget.onModeChanged(selected);
                    },
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color: widget.useCustomCity ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (widget.useCustomCity)
              TextField(
                controller: widget.cityController,
                decoration: InputDecoration(
                  labelText: 'Введите город',
                  hintText: 'Например: Сочи, Казань, Владивосток',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_city),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: widget.onSearchPressed,
                  ),
                ),
                onSubmitted: (value) => widget.onSearchPressed(),
              )
            else
              DropdownButtonFormField<String>(
                value: widget.selectedCity,
                decoration: const InputDecoration(
                  labelText: 'Выберите город',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: widget.cities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: widget.onCitySelected,
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: widget.onSearchPressed,
              icon: const Icon(Icons.search),
              label: const Text('Узнать погоду'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
