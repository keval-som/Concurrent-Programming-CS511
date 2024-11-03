import java . util . concurrent . Semaphore
Semaphore mutexS = new Semaphore (1)
Semaphore mutexF = new Semaphore (1)
Semaphore studentPermit = new Semaphore (1)
Semaphore facultyPermit  = new Semaphore (1)
final int S = 10 // Number of students
final int F = 10 // Number of faculty
final int CM = 3 // Number of cleaning machines
S. times {
int id = it
Thread . start { // Student
// complete
        mutexS.acquire()
        s++
        if(s==1) {
            studentPermit.acquire()
        }
        mutexS.release()
        //eating
        mutexS.acquire()
        s--
        if(s==0) {
            studentPermit.release()
        }
        mutexS.release()
    }
}

F. times {
    int id = it
    Thread . start { // Faculty
        // complete
        mutexF.acquire()
        f++
        if(f==0) {
            facultyPermit.acquire()
        }
        mutexF.release()
        //eating
        mutexF.acquire()
        f--
        if(f==0) {
            facultyPermit.release()
        }
        mutexF.release()
    }
}
CM . times {
int id = it
Thread . start { // Clean
while ( true ) {
// complete
    studentPermit.acquire()
    facultyPermit.acquire() 
    //cleaning
    facultyPermit.release()
    studentPermit.release()
}
 }
}