Semaphore allowA = new Semaphore (1) ;
Semaphore allowB = new Semaphore (1) ;
Thread . start { // P
    while ( true ) {
        allowA . acquire () ;
        print ( " A " ) ;
        allowB . release () ;
    }
}
Thread . start { // Q
    while ( true ) {
        allowB . acquire () ;
        print ( " B " ) ;
        allowA . release () ;
    }
}