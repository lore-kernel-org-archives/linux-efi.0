From: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] partitions/efi: Ignore errors when alternate GPT is not
 at the end of disk
Date: Tue, 18 Oct 2016 11:56:37 +0200
Message-ID: <20161018095637.tgdjehscttskqz5q@ws.net.home>
References: <1476699630-127009-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1476699630-127009-1-git-send-email-hare-l3A5Bk7waGM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: Davidlohr Bueso <dbueso-IBi9RG/b67k@public.gmane.org>, Jens-l3A5Bk7waGM@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Oct 17, 2016 at 12:20:30PM +0200, Hannes Reinecke wrote:
> The GPT specification requires that the alternate GPT is at the
> end of the disk. However, if a Software RAID1 is enabled the RAID
> metadata typically placed at the end of the disk, and the actual
> size of the disk is decreased by the size of the metadata.

This is not about GPT, but about kernel. It does not support this
use-case and it parses PT on wrong device. If I good remember udev
should be smart enough to remove (by partx) such partitions and 
re-create on /dev/mdX. 

The real solution is to use RAID1 signatures on the begin of the disk.
This problem is generic, not specific to GPT.

> Plus it's perfectly legit to have a partition table which is
> _smaller_ than the device

Well, this is reason why GPT differentiate between headers position
and usable area (addressed by {First,Last}UsableLba within the header.

> eg we don't check for the device
> size in the msdos partition, neither.

All the "backup" GPT stuff is based on well known place for the backup
header. How do you want to reliably support GPT recovery from the
backup header if there is no explicit place for the header? 

Let's imagine your primary header is broken and alternate_lba is
unreliable (or zero, etc.), where is the backup header?

    Karel

-- 
 Karel Zak  <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 http://karelzak.blogspot.com
