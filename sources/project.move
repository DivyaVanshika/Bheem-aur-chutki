module MyModule::AcademicLeaderboard { 
    use aptos_framework::signer;

    /// Struct to store student scores.
    struct LeaderboardEntry has key, store {
        student: address,    // Address of the student
        score: u64,          // Student's score
    }

    /// Function to submit or update a student's score.
    public fun submit_score(student: &signer, score: u64) acquires LeaderboardEntry {
        let student_address = signer::address_of(student);

        if (exists<LeaderboardEntry>(student_address)) {
            // Update existing score
            let entry = borrow_global_mut<LeaderboardEntry>(student_address);
            entry.score = score;
        } else {
            // Create new entry
            let new_entry = LeaderboardEntry {
                student: student_address,
                score,
            };
            move_to(student, new_entry);
        }
    }

    /// Function to retrieve the score of a student.
    public fun get_score(student: address): u64 acquires LeaderboardEntry {
        if (exists<LeaderboardEntry>(student)) {
            let entry = borrow_global<LeaderboardEntry>(student);
            entry.score
        } else {
            0 // Return 0 if the student does not exist
        }
    }
}
