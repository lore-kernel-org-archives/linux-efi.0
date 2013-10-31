From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [PATCH 0/2] make all stored entries accessible.
Date: Thu, 31 Oct 2013 23:22:55 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DBBA3@USINDEM103.corp.hds.com>
References: <1383126294-28793-1-git-send-email-cxie@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F31D529D7@ORSMSX106.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D4476@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F31D52E99@ORSMSX106.amr.corp.intel.com>
 <87d2mm6t64.fsf@gmail.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D4D01@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F31D53A1F@ORSMSX106.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D53A1F-P5GAC/sN6hlZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Madper Xie <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org" <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, "anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org" <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> I also like option 1 ... but I think the "id" should be a persistent value for
> a given saved record.  So some func(timestamp, part, count) would be a
> good idea.  If we try using "sequential" numbers - and don't manage to
> clear out /sys/fs/pstore each time - then we may have the same "dmesg"
> file show up with different names on each boot.
> 
> Right now I have a simple script to save & clear ... not much more
> complex than:
> 
> 	cd /sys/fs/pstore
> 	cp * /var/log/save-pstore
> 	rm *
> 
> This depends on not re-using filenames (otherwise new files in pstore
> might overwrite older saved files in my /var/log/save-pstore area).

I see.. It is a persuasive use case.

(1) I agree that some func(timestamp, part, count) would be  good idea.
      This might work, although an overflow will happen some time...
      sprintf(id_str, "%lld%d%d", timestamp, part, count)
      simple_str_to_ull(id_str, &id, base)
 
(2) There is a GetNextHighMonotonicCount() runtime service in EFI specification
       to get a persistent number across the reboot, but I'm not sure if it is safe to use it..
      Also,  it would be good if we can create the id by ourselves, rather than using firmware.

 (3) Also, (it might not be good idea),  if a pstore filesystem expects all backend drivers
       to use the persistent id, the pstore should provide it by itself.
       (by using time stamp counter or something like that.)

       As I looked into the ramoops's code. It seems to use a non-persistent sequential counter,by initializing
       read_cnt to "0" in ramoops_pstore_open(), and incrementing it in ramoops_pstore_read().
       It doesn't seem to be the pstore's expectation. 
       And when someone introduces a new driver, they may misunderstand how to create the id as well..

As above, there are mutiple ideas, but (1) is reasonable to me.    
 
Seiji
