From: "kzak@redhat.com" <kzak@redhat.com>
Subject: Re: [PATCH v2] efi: take size of partition entry from GPT header
Date: Fri, 14 Sep 2018 13:07:03 +0200
Message-ID: <20180914110703.ishvqwcpcf5ozihy@ws.net.home>
References: <20180911161527.GA30689@vnote>
 <20180912083844.iegei2kobcz4b7ag@ws.net.home>
 <6d349d22d37041c1a2942d8ed4c76b69@AcuMS.aculab.com>
 <CAJC2YLaug4=7otnRC7x+UdDp=5ErgJFHFL_7mjRO7sdM2CrUfQ@mail.gmail.com>
 <2db38b2d1af34ab9b653c665d08872f1@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2db38b2d1af34ab9b653c665d08872f1@AcuMS.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Eugene Korenevsky' <ekorenevsky@gmail.com>, Davidlohr Bueso <dave@stgolabs.net>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Sep 14, 2018 at 09:01:48AM +0000, David Laight wrote:
> From: Eugene Korenevsky
> > Sent: 13 September 2018 20:48
> > 
> > > I suspect you also need a sanity check that the value isn't too small
> > > or stupidly large.
> > 
> > What would be the criterion for too large entries?
> 
> Anything larger than the maximum size of the full GPT table
> would be a start.
> Even something like 64k would stop later calculations going wrong.
> I presume there is a check elsewhere that the GPT table entries
> are all inside the disk area that was read?

is_gpt_valid() already contains 

        pt_size = (u64)le32_to_cpu((*gpt)->num_partition_entries) *
                le32_to_cpu((*gpt)->sizeof_partition_entry);
        if (pt_size > KMALLOC_MAX_SIZE)
                pr_debug("GUID Partition Table is too large: %llu > %lu bytes\n",
                (unsigned long long)pt_size, KMALLOC_MAX_SIZE);
                goto fail;
        }      

I guess it good enough for sanity check.

If you want to be really paranoid than you can also check that array
is possible to store to the expected area on the disk:

    pt_size <= (gpt->first_usable_lba - gpt->partition_entry_lba)

Note that is_gpt_valid() already compares the another LBAs with the 
device size to be sure GPT is no out of reality...

    Karel


-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
