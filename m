From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] partitions/efi: Fix integer overflow in GPT size
 calculation
Date: Tue, 17 Jan 2017 08:03:14 -0800
Message-ID: <3c9bc8f7-7fb8-64d7-f195-7aadfd2cbb14@kernel.dk>
References: <1484519516-18295-1-git-send-email-alden.tondettar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484519516-18295-1-git-send-email-alden.tondettar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alden Tondettar <alden.tondettar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 01/15/2017 02:31 PM, Alden Tondettar wrote:
> If a GUID Partition Table claims to have more than 2**25 entries, the
> calculation of the partition table size in alloc_read_gpt_entries() will
> overflow a 32-bit integer and not enough space will be allocated for the
> table.
> 
> Nothing seems to get written out of bounds, but later efi_partition() will
> read up to 32768 bytes from a 128 byte buffer, possibly OOPSing or exposing
> information to /proc/partitions and uevents.
> 
> The problem exists on both 64-bit and 32-bit platforms.
> 
> Fix the overflow and also print a meaningful debug message if the table
> size is too large.

Applied for 4.11, thanks.

-- 
Jens Axboe
