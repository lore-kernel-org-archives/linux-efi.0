From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH] block: partitions: efi: Always check for alternative
 GPT at end of drive
Date: Tue, 26 Apr 2016 20:34:14 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402963904365@G4W3296.americas.hpqcorp.net>
References: <1461632806-5946-1-git-send-email-jwerner@chromium.org>
 <20160426102014.o7k77uzi32h73y3b@ws.net.home>
 <20160426183353.GB16601@linux-uzut.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160426183353.GB16601@linux-uzut.site>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>, Karel Zak <kzak@redhat.com>
Cc: Julius Werner <jwerner@chromium.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>, Doug Anderson <dianders@chromium.org>
List-Id: linux-efi@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Davidlohr Bueso
> Sent: Tuesday, April 26, 2016 1:34 PM
> To: Karel Zak <kzak@redhat.com>
> Cc: Julius Werner <jwerner@chromium.org>; linux-efi@vger.kernel.org;
> linux-kernel@vger.kernel.org; linux-block@vger.kernel.org; Gwendal
> Grignou <gwendal@chromium.org>; Doug Anderson <dianders@chromium.org>
> Subject: Re: [PATCH] block: partitions: efi: Always check for
> alternative GPT at end of drive
> 
> On Tue, 26 Apr 2016, Karel Zak wrote:
> 
> >On Mon, Apr 25, 2016 at 06:06:46PM -0700, Julius Werner wrote:
> >> The GUID Partiton Table layout maintains two synonymous partition
> >> tables on a block device, one starting in sector 1 and one in the
> >> very last sectors of the block device. This is useful if one of
> >> the tables gets
> >> accidentally corrupted (e.g. through a partial write because of an
> >> unexpected power loss).
> >>
> >> Linux normally only boots if the primary GPT is valid. It will not
> >> even try to find the alternative GPT to an invalid primary one
> >> unless the "gpt" command line option forces more aggressive
> >> detection. This doesn't
> >> really make any sense... if the "gpt" option is not set, the code
> >> validates the protective or hybrid MBR in sector 0 anyway before
> >> it even starts looking for the actual GPTs. If we get to the point
> >> where a valid proctective or hybrid MBR was found but the primary
> >> GPT was not found (valid), checking the alternative GPT is our 
> >> best bet: we know that this
> 
> 'best bet' in a kernel is not enough :) Which is why userland tools
> can fix and/or do any sort of crazy stuff with the backup and recover
> the primary etc etc.

Drive blocks go bad; the redundant GPTs are there to let the
system keep booting and running if that happens.

Rewriting the bad GPTs is what should require user intervention.

> 
> >> block device is meant to use GPT (because any other partitioning
> system
> >> would've presumably overwritten sector 0), and we know that if the
> >> alternative GPT is valid it should contain more accurate
> information
> >> than parsing the protective/hybrid MBR with msdos_partition()
> would
> >> yield (which would otherwise be what happens next).
> 
> >I guess "force_gpt" (and "gpt" on kernel command line) exists to
> >force users to think and care about a reason why the device has
> >unreadable (broken) primary GPT header.
> 
> Yes, from find_valid_gpt():
> 
>  * If the Primary GPT header is not valid, the Alternate GPT header
>  * is not checked unless the 'gpt' kernel command line option is
> passed.
>  * This protects against devices which misreport their size, and
> forces
>  * the user to decide to use the Alternate GPT.
> 
> ... so users are at least forced in some way to think about this.
> 
> >It seems like bad (and dangerous) idea to silently ignore corrupted
> >primary GTP header and boot from such device.
> 
> Yeah, there's no way in hell I trust a backup gpt in kernel space.
> We simply have no way of distinguishing between good and bad devices.
>
> >And note that alternative GPT header and the end of the device is a
> >just guess. The proper location of the alternative header is
> >specified with-in primary header (pgpt->alternate_lba). The header
> >at the end of
> >the device (as used for "force_gpt") is a fallback solution only.
> 
> And this only illustrates the ambiguity of the backup.

The UEFI specification is not ambiguous - you should always look
for the backup GPT Header at the last LBA:

"Two GPT Header structures are stored on the device: the primary
and the backup. The primary GPT Header must be located in LBA 1
(i.e., the second logical block), and the backup GPT Header must
be located in the last LBA of the device."

If the primary GPT Header is corrupted (e.g., CRC is bad), you
cannot trust any fields in it, including the Alternate LBA field.
The Alternate LBA field is there to help you tolerate failures 
while growing or shrinking the block device size (not important
for individual physical drives, but an issue for logical drives
presented by RAID controllers).
