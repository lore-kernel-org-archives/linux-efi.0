From: Julius Werner <jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] block: partitions: efi: Always check for alternative GPT
 at end of drive
Date: Tue, 26 Apr 2016 13:13:04 -0700
Message-ID: <CAODwPW9YOS=xVmiHUSKMJi3CBPeQp-afEGRbuRLCg7RHVmS_tQ@mail.gmail.com>
References: <1461632806-5946-1-git-send-email-jwerner@chromium.org>
	<20160426102014.o7k77uzi32h73y3b@ws.net.home>
	<20160426183353.GB16601@linux-uzut.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160426183353.GB16601-95RKjC4jbl+7r5TWoziOLQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Cc: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Julius Werner <jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Doug Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

>> I guess "force_gpt" (and "gpt" on kernel command line) exists to force
>> users to think and care about a reason why the device has unreadable
>> (broken) primary GPT header.
>
>
> Yes, from find_valid_gpt():
>
> * If the Primary GPT header is not valid, the Alternate GPT header
> * is not checked unless the 'gpt' kernel command line option is passed.
> * This protects against devices which misreport their size, and forces
> * the user to decide to use the Alternate GPT.
>
> ... so users are at least forced in some way to think about this.

Are you sure that not recognizing the device at all (rather than
spitting a warning and using the still valid information we have, as
it would do with my patch) is better for the user? This does not just
apply to the root device, after all... GPTs on any (possibly external)
medium will not be recognized if the primary table is broken. If a
novice user just wants to read a slightly corrupted USB stick on his
Ubuntu desktop, he has to dig through dmesg to find the reason it
doesn't auto-mount, then figure out somehow that he has to add "gpt"
to his command line (which the error messages don't allude to in any
way), and reboot the whole system to make it apply.

I agree that broken GPTs should be fixed, of course. But unless you
want the kernel to fix them itself, the only option is to spew a
warning and let some userspace tool look for that. With this patch,
any distro would be free to add a simple 'if dmesg | grep "Primary GPT
is invalid"; then parted --whatever-you-need-to-pass-to-fix-it; fi'
init script. But without it, you're going to throw the user to a grub
prompt or worse (e.g. what if it's a phone or something?), possibly
cutting off his only source of internet access and expecting him to
figure out the magic option he needs to make it work again on his own.

Another argument is that GPTs mostly break on update... disks
(usually) don't just corrupt themselves randomly. If your primary GPT
is broken but the secondary is valid, you're probably fine until you
try to repartition the device again, at which point any good
partitioning tool will detect and fix the problem before it let's you
make any more changes anyway.

>> It seems like bad (and dangerous) idea to silently ignore corrupted
>> primary GTP header and boot from such device.
>
>
> Yeah, there's no way in hell I trust a backup gpt in kernel space.
> We simply have no way of distinguishing between good and bad devices.

I'm not sure what you're getting at here. The alternative GPT is just
as trustworthy and as protected by checksums as the primary. If it's
there, and it's valid, and you had a valid PMBR, I don't see how
there's any realistic chance that this is not a GPT device.

>> And note that alternative GPT header and the end of the device is a
>> just guess. The proper location of the alternative header is specified
>> with-in primary header (pgpt->alternate_lba). The header at the end of
>> the device (as used for "force_gpt") is a fallback solution only.
>
> And this only illustrates the ambiguity of the backup.

The GPT specification mandates the alternative GPT header to be in the
last sector on disk. That is the only proper and valid location...
pgpt->alternative_lba is just a redundant aid to double-check it. If
it's not there (maybe because you dd'ed a disk onto a
differently-sized disk), that is just plain incorrect. Sure, it
happens, but that's fine... in that case this code just won't find a
valid GPT at the end and fail. But if it does find a GPT, and it is
valid, I really don't see why we shouldn't just use it.
