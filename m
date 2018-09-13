From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v3] efi: take size of partition entry from GPT header
Date: Thu, 13 Sep 2018 13:25:07 +0000
Message-ID: <c158b639852d48d382445d33da8c6a1e@AcuMS.aculab.com>
References: <20180912183519.GA31506@vnote> <20180912185517.GE3902@linux-r8p5>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180912185517.GE3902@linux-r8p5>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Davidlohr Bueso' <dave@stgolabs.net>, Eugene Korenevsky <ekorenevsky@gmail.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Davidlohr Bueso
> Sent: 12 September 2018 19:55
> 
> On Wed, 12 Sep 2018, Eugene Korenevsky wrote:
> > /**
> >  * efi_partition(struct parsed_partitions *state)
> >  * @state: disk parsed partitions
> >@@ -704,32 +710,36 @@ int efi_partition(struct parsed_partitions *state)
> >
> > 	pr_debug("GUID Partition Table is valid!  Yea!\n");
> >
> >-	for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) && i < state->limit-1; i++) {
> >+	for (i = 0;
> >+	     i < le32_to_cpu(gpt->num_partition_entries) && i < state->limit-1;
> >+	     i++) {
> 
> Please rearrange this like:
> 
>        for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) &&
>        	      	      i < state->limit-1; i++)

Better still cache le32_to_cpu(gpt->num_partition_entries) to a local
so that it only has to be calculated once (even if it gets spilled
to the stack).
It can be bounded by state->limit-1 at the same time.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
