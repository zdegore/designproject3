


class CTCoffice():
    def __init__(self):
        #mode 0 train  1 station  2 track
        self.mode = 0

        #train info
        self.authority = ""
        self.suggested_speed = 0
        self.train_id = 0
        self.arrival_time = ""
        self.destination = ""
        self.passengers = 0
        self.location = int(1)

    def update(self, type: int):
        self.type = type

    def setMode(self, type: int):
        self.mode = type

    def setAuthority(self, auth: str):
        self.authority = auth

    def setSuggestedSpeed(self, speed: int):
        self.speed = speed

    def setTrainID(self, id: int):
        self.train_id = id

    def setArrival_time(self, time: str):
        self.arrival_time = time

    def setDestination(self, destination: int):
        self.destination = destination

    def getVal(self):
        return self.destination

    def calcAuthority(self):
        if(self.destination == 1):
            return 10
        else:
            return 15

    def calcSuggestedSpeed(self):
        return 50
