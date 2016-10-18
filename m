From: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] partitions/efi: Ignore errors when alternate GPT is not
 at the end of disk
Date: Tue, 18 Oct 2016 12:07:26 +0200
Message-ID: <d8d1bd3d-d183-cf00-98a8-1bbe5e03fa3b@suse.com>
References: <1476699630-127009-1-git-send-email-hare@suse.de>
 <20161018095637.tgdjehscttskqz5q@ws.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161018095637.tgdjehscttskqz5q-xkT7n84Rsxv/9pzu0YdTqQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: Davidlohr Bueso <dbueso-IBi9RG/b67k@public.gmane.org>, Jens-l3A5Bk7waGM@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 10/18/2016 11:56 AM, Karel Zak wrote:
> On Mon, Oct 17, 2016 at 12:20:30PM +0200, Hannes Reinecke wrote:
>> The GPT specification requires that the alternate GPT is at the
>> end of the disk. However, if a Software RAID1 is enabled the RAID
>> metadata typically placed at the end of the disk, and the actual
>> size of the disk is decreased by the size of the metadata.
> 
> This is not about GPT, but about kernel. It does not support this
> use-case and it parses PT on wrong device. If I good remember udev
> should be smart enough to remove (by partx) such partitions and 
> re-create on /dev/mdX. 
> 
And introducing a nice race condition when doing so.
Yes, I've noticed :-(

> The real solution is to use RAID1 signatures on the begin of the disk.
> This problem is generic, not specific to GPT.
> 
I would if I had a choice.

To quote SNIA DDF:

'The Anchor Header for the DDF structure MUST be stored on the last
logical block returned by either the ATA Identify Device or SCSI Read
Capacity commands depending on the type of physical disk.'

Emphasis is from the document.

>> Plus it's perfectly legit to have a partition table which is
>> _smaller_ than the device
> 
> Well, this is reason why GPT differentiate between headers position
> and usable area (addressed by {First,Last}UsableLba within the header.
> 
>> eg we don't check for the device
>> size in the msdos partition, neither.
> 
> All the "backup" GPT stuff is based on well known place for the backup
> header. How do you want to reliably support GPT recovery from the
> backup header if there is no explicit place for the header? 
> 
> Let's imagine your primary header is broken and alternate_lba is
> unreliable (or zero, etc.), where is the backup header?
> 
Sure, if things are broken we have to back off.

But if things are not broken (as is the case here), and the GPT is just
formatted for a smaller disk, why do we care?
Or, to put it the other way round:
Why do we care for GPT but not for msdos?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare-IBi9RG/b67k@public.gmane.org			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
