import java.util.concurrent.Semaphore

Semaphore mutexS = new Semaphore(1)
Semaphore mutexF = new Semaphore(1)
Semaphore studentPermit = new Semaphore(1)
Semaphore facultyPermit = new Semaphore(1)

int studentsInLounge = 0
int facultyInLounge = 0

final int S = 10 // Number of students
final int F = 10 // Number of faculty
final int CM = 3 // Number of cleaning machines

S.times {
    int id = it
    Thread . start { // Student
        // complete
        mutexS.acquire()
        studentsInLounge++
        if(studentsInLounge == 1){
            studentPermit.acquire()
        }
        mutexS.release()
        println("Student $id is in the lounge")
        Thread.sleep(100);
        mutexS.acquire()
        studentsInLounge--
        if(studentsInLounge == 0){
            println("All Students leaving the lounge")
            studentPermit.release()
        }
        mutexS.release()
    }
}

F.times {
    int id = it
    Thread . start { // Faculty
        // complete
        mutexF.acquire()
        facultyInLounge++
        if(facultyInLounge == 1){
            facultyPermit.acquire()
        }
        mutexF.release()
        println("Faculty $id is in the lounge")
        Thread.sleep(100);
        mutexF.acquire()
        facultyInLounge--
        if(facultyInLounge == 0){
            println("All Faculty leaving the lounge")
            facultyPermit.release()
        }
        mutexF.release()
    }
}

CM.times {
    int id = it
    Thread . start { // Cleaning machine
        // complete
        while(true){
            studentPermit.acquire()
            facultyPermit.acquire()
            println("Cleaning machine $id is cleaning")
            Thread.sleep(10000);
            println("Cleaning machine $id is done cleaning")
            studentPermit.release()
            facultyPermit.release()
        }
    }
}