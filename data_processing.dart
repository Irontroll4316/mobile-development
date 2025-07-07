import "dart:io";

void main(List<String> arguments)
{
  if(arguments.isEmpty)
  {
    print("Usage: dart data_processing.dart <input_file.csv");
    exit(1);
  }
  
  final input_file = arguments[0];
  
  final lines = File(input_file).readAsLinesSync();
  final total_duration_by_tag = <String, double>{};
  lines.removeAt(0);
  var total_duration = 0.0;
  for (var line in lines)
  {
    final values = line.split(',');
    final durationstr = values[3].replaceAll('"', '');
    final duration = double.parse(durationstr);
    final tag = values[5].replaceAll('"', '');
    final previous_total = total_duration_by_tag[tag];
    if(previous_total == null)
    {
      total_duration_by_tag[tag] = duration;
    } else {
      total_duration_by_tag[tag] = previous_total + duration;
    }
    total_duration += duration;
  }

  for (var entry in total_duration_by_tag.entries)
  {
    final formatted_duration = entry.value.toStringAsFixed(1);
    final tag = entry.key == '' ? "Unallocated" : entry.key;
    print("$tag: ${formatted_duration}h");
  } 
  print("Total for all tags: ${total_duration.toStringAsFixed(1)}h");
}