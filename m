From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v2] efi: take size of partition entry from GPT header
Date: Thu, 13 Sep 2018 13:06:13 +0000
Message-ID: <6d349d22d37041c1a2942d8ed4c76b69@AcuMS.aculab.com>
References: <20180911161527.GA30689@vnote>
 <20180912083844.iegei2kobcz4b7ag@ws.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180912083844.iegei2kobcz4b7ag@ws.net.home>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Karel Zak' <kzak@redhat.com>, Eugene Korenevsky <ekorenevsky@gmail.com>, Davidlohr Bueso <dave@stgolabs.net>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Karel Zak
> Sent: 12 September 2018 09:39
> On Tue, Sep 11, 2018 at 07:15:27PM +0300, Eugene Korenevsky wrote:
> > +static gpt_entry *get_gpt_entry(gpt_header *gpt_hdr, gpt_entry *ptes, u32 index)
> > +{
> > +	return (gpt_entry *)((u8 *)ptes + gpt->sizeof_partition_entry * index);
> 
> I guess header use LE, so you need:
> 
>                le32_to_cpu(gpt_hdr->sizeof_partition_entry)

I suspect you also need a sanity check that the value isn't too small
or stupidly large.

In principle slightly short lengths presumably imply that the disk
was formatted with an older standard - so the last fields should be
ignored.
They may not be any such disks - until the on-disk structure is extended
and the kernel structure updated to match.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
