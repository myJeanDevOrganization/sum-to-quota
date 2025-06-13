# sum-to-quota  
A game where you select boxes of numbers to sum to a quota.  

# Components  

+ MAP_LAYER_SAVES (an array of map layer packed scenes)
```
const MAP_LAYER_SAVES: Array[PackedScene] = [
	preload("res://mapLayer0.tscn"),
  preload("res://mapLayer1.tscn"),
  ...
]
```

+ MENU: MAIN  
  - Button: Start  
  - Button: Settings  

+ PLAY_SPACE  
  - TileMapLayer  
  - Display: Score  
  - Display: Quota Bucket  
  - Display: Timer  

+ MENU: DAY_START  
  - Display: Day Number  
  - Display: New Day Rule  
  - Display: New Day Quotas  

+ MENU: UPGRADE  
  - Button(X3): Upgrade  

+ MENU: WIN  
  - Display: Day Count  
  - Button: Main Menu  
