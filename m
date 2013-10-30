From: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] pstore: avoid incorrectly mark entry as duplicate
Date: Wed, 30 Oct 2013 22:51:07 +0800
Message-ID: <87txfyhkx0.fsf@redhat.com>
References: <1383126294-28793-1-git-send-email-cxie@redhat.com> <1383126294-28793-2-git-send-email-cxie@redhat.com> <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D388F@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D388F-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "tony.luck@intel.com" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "keescook@chromium.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "ccross@android.com" <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, "anton@enomsg.org" <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, "linux-efi@vger.kernel.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "bbboson@gmail.com" <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


seiji.aguchi-7rDLJAbr9SE@public.gmane.org writes:

>> -----Original Message-----
>> From: Madper Xie [mailto:cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
>> Sent: Wednesday, October 30, 2013 5:45 AM
>> To: tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org; ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org; anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org; Seiji Aguchi
>> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; Madper Xie
>> Subject: [PATCH 1/2] pstore: avoid incorrectly mark entry as duplicate
>> 
>> From: Madper Xie <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> 
>> pstore try to find duplicate entries by check both ID, type and psi.
>> They are not really enough for efi backend. dumped vars always have
>> the same type, psi and ID. like follows:
>> dump-type0-9-1-1382511508-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
>> dump-type0-9-1-1382515661-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
>> 
>> The "duplicate" entries won't appear in pstorefs. And a complain will be
>> print -- pstore: failed to load 76 record(s) from 'efi'
>> So I add two more checks: timespec and count.
>> 
>> Signed-off-by: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> Looks good to me.
> Acked-by: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
>
> But, this patch has to be tested by other backend drivers like erst and ramoops.
> In my understanding, erst has supported to log multiple events.
> So, I'm interested why the same error hasn't happened in the other drivers.
>
> Seiji
Thanks for your review. I'll try to test other backends. :-)
>
>> ---
>>  fs/pstore/inode.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>> 
>> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
>> index 1282384..0ae994c 100644
>> --- a/fs/pstore/inode.c
>> +++ b/fs/pstore/inode.c
>> @@ -47,6 +47,7 @@ static LIST_HEAD(allpstore);
>>  struct pstore_private {
>>  	struct list_head list;
>>  	struct pstore_info *psi;
>> +	struct timespec time;
>>  	enum pstore_type_id type;
>>  	u64	id;
>>  	int	count;
>> @@ -290,7 +291,9 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
>>  	list_for_each_entry(pos, &allpstore, list) {
>>  		if (pos->type == type &&
>>  		    pos->id == id &&
>> -		    pos->psi == psi) {
>> +		    pos->psi == psi &&
>> +		    pos->count == count &&
>> +		    !timespec_compare(&pos->time, &time)) {
>>  			rc = -EEXIST;
>>  			break;
>>  		}
>> @@ -312,6 +315,7 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
>>  	private->id = id;
>>  	private->count = count;
>>  	private->psi = psi;
>> +	memcpy(&private->time, &time, sizeof(struct timespec));
>> 
>>  	switch (type) {
>>  	case PSTORE_TYPE_DMESG:
>> --
>> 1.8.4.2


-- 
Best,
Madper Xie.
