From: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] block: partitions: efi: Always check for alternative GPT
 at end of drive
Date: Tue, 26 Apr 2016 12:20:14 +0200
Message-ID: <20160426102014.o7k77uzi32h73y3b@ws.net.home>
References: <1461632806-5946-1-git-send-email-jwerner@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461632806-5946-1-git-send-email-jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julius Werner <jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Doug Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Apr 25, 2016 at 06:06:46PM -0700, Julius Werner wrote:
> The GUID Partiton Table layout maintains two synonymous partition tables
> on a block device, one starting in sector 1 and one in the very last
> sectors of the block device. This is useful if one of the tables gets
> accidentally corrupted (e.g. through a partial write because of an
> unexpected power loss).
> 
> Linux normally only boots if the primary GPT is valid. It will not even
> try to find the alternative GPT to an invalid primary one unless the
> "gpt" command line option forces more aggressive detection. This doesn't
> really make any sense... if the "gpt" option is not set, the code
> validates the protective or hybrid MBR in sector 0 anyway before it even
> starts looking for the actual GPTs. If we get to the point where a valid
> proctective or hybrid MBR was found but the primary GPT was not found
> (valid), checking the alternative GPT is our best bet: we know that this
> block device is meant to use GPT (because any other partitioning system
> would've presumably overwritten sector 0), and we know that if the
> alternative GPT is valid it should contain more accurate information
> than parsing the protective/hybrid MBR with msdos_partition() would
> yield (which would otherwise be what happens next).

I guess "force_gpt" (and "gpt" on kernel command line) exists to force
users to think and care about a reason why the device has unreadable
(broken) primary GPT header.

It seems like bad (and dangerous) idea to silently ignore corrupted 
primary GTP header and boot from such device.

And note that alternative GPT header and the end of the device is a
just guess. The proper location of the alternative header is specified
with-in primary header (pgpt->alternate_lba). The header at the end of
the device (as used for "force_gpt") is a fallback solution only.

    Karel

-- 
 Karel Zak  <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 http://karelzak.blogspot.com
