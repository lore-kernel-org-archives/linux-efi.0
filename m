From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] block: partitions: efi: Always check for alternative GPT
 at end of drive
Date: Wed, 27 Apr 2016 08:00:38 +0200
Message-ID: <CAKv+Gu9UnTnWQt7Q6p3CWbmn8sufcxgYcVo=KD68Wg1=1rrzdw@mail.gmail.com>
References: <1461632806-5946-1-git-send-email-jwerner@chromium.org>
	<20160426102014.o7k77uzi32h73y3b@ws.net.home>
	<20160426183353.GB16601@linux-uzut.site>
	<94D0CD8314A33A4D9D801C0FE68B402963904365@G4W3296.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402963904365-wwDBVnaDRpYSZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>
Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Julius Werner <jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Doug Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 26 April 2016 at 22:34, Elliott, Robert (Persistent Memory)
<elliott-ZPxbGqLxI0U@public.gmane.org> wrote:
>
>
>> -----Original Message-----
>> From: linux-kernel-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-kernel-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Davidlohr Bueso
>> Sent: Tuesday, April 26, 2016 1:34 PM
>> To: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: Julius Werner <jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>; linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
>> linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Gwendal
>> Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>; Doug Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> Subject: Re: [PATCH] block: partitions: efi: Always check for
>> alternative GPT at end of drive
>>
>> On Tue, 26 Apr 2016, Karel Zak wrote:
>>
>> >On Mon, Apr 25, 2016 at 06:06:46PM -0700, Julius Werner wrote:
>> >> The GUID Partiton Table layout maintains two synonymous partition
>> >> tables on a block device, one starting in sector 1 and one in the
>> >> very last sectors of the block device. This is useful if one of
>> >> the tables gets
>> >> accidentally corrupted (e.g. through a partial write because of an
>> >> unexpected power loss).
>> >>
>> >> Linux normally only boots if the primary GPT is valid. It will not
>> >> even try to find the alternative GPT to an invalid primary one
>> >> unless the "gpt" command line option forces more aggressive
>> >> detection. This doesn't
>> >> really make any sense... if the "gpt" option is not set, the code
>> >> validates the protective or hybrid MBR in sector 0 anyway before
>> >> it even starts looking for the actual GPTs. If we get to the point
>> >> where a valid proctective or hybrid MBR was found but the primary
>> >> GPT was not found (valid), checking the alternative GPT is our
>> >> best bet: we know that this
>>
>> 'best bet' in a kernel is not enough :) Which is why userland tools
>> can fix and/or do any sort of crazy stuff with the backup and recover
>> the primary etc etc.
>
> Drive blocks go bad; the redundant GPTs are there to let the
> system keep booting and running if that happens.
>
> Rewriting the bad GPTs is what should require user intervention.
>
>>
>> >> block device is meant to use GPT (because any other partitioning
>> system
>> >> would've presumably overwritten sector 0), and we know that if the
>> >> alternative GPT is valid it should contain more accurate
>> information
>> >> than parsing the protective/hybrid MBR with msdos_partition()
>> would
>> >> yield (which would otherwise be what happens next).
>>
>> >I guess "force_gpt" (and "gpt" on kernel command line) exists to
>> >force users to think and care about a reason why the device has
>> >unreadable (broken) primary GPT header.
>>
>> Yes, from find_valid_gpt():
>>
>>  * If the Primary GPT header is not valid, the Alternate GPT header
>>  * is not checked unless the 'gpt' kernel command line option is
>> passed.
>>  * This protects against devices which misreport their size, and
>> forces
>>  * the user to decide to use the Alternate GPT.
>>
>> ... so users are at least forced in some way to think about this.
>>
>> >It seems like bad (and dangerous) idea to silently ignore corrupted
>> >primary GTP header and boot from such device.
>>
>> Yeah, there's no way in hell I trust a backup gpt in kernel space.
>> We simply have no way of distinguishing between good and bad devices.
>>
>> >And note that alternative GPT header and the end of the device is a
>> >just guess. The proper location of the alternative header is
>> >specified with-in primary header (pgpt->alternate_lba). The header
>> >at the end of
>> >the device (as used for "force_gpt") is a fallback solution only.
>>
>> And this only illustrates the ambiguity of the backup.
>
> The UEFI specification is not ambiguous - you should always look
> for the backup GPT Header at the last LBA:
>
> "Two GPT Header structures are stored on the device: the primary
> and the backup. The primary GPT Header must be located in LBA 1
> (i.e., the second logical block), and the backup GPT Header must
> be located in the last LBA of the device."
>
> If the primary GPT Header is corrupted (e.g., CRC is bad), you
> cannot trust any fields in it, including the Alternate LBA field.
> The Alternate LBA field is there to help you tolerate failures
> while growing or shrinking the block device size (not important
> for individual physical drives, but an issue for logical drives
> presented by RAID controllers).
>

What the UEFI spec stipulates is not really relevant for the kernel.
So the firmware must use the backup GPT if the CRC of the primary one
indicates that it is corrupted, fine. Once we are in the kernel, the
policy is currently different, which makes sense since we are not only
mounting the boot device, but other block devices as well.
