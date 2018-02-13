From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH] efi/apple-properties: Delete an error message for a
 failed memory allocation in unmarshal_devices()
Date: Tue, 13 Feb 2018 19:40:33 +0100
Message-ID: <20180213184033.GA24299@wunner.de>
References: <145f8fac-9297-b362-d89f-886632e2507f@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <145f8fac-9297-b362-d89f-886632e2507f@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 13, 2018 at 06:00:26PM +0100, SF Markus Elfring wrote:
> Omit an extra message for a memory allocation failure in this function.
[snip]
> --- a/drivers/firmware/efi/apple-properties.c
> +++ b/drivers/firmware/efi/apple-properties.c
> @@ -158,10 +158,8 @@ static int __init unmarshal_devices(struct properties_header *properties)
>  
>  		entry = kcalloc(dev_header->prop_count + 1, sizeof(*entry),
>  				GFP_KERNEL);
> -		if (!entry) {
> -			dev_err(dev, "cannot allocate properties\n");
> +		if (!entry)
>  			goto skip_device;
> -		}
>  
>  		unmarshal_key_value_pairs(dev_header, dev, ptr, entry);
>  		if (!entry[0].name)

While the allocator does print an error when allocations fail,
it may not be immediately apparent to the user what the
*consequences* are.  In this case, the consequence is that the
device properties will not be available for consumption by
drivers and they may fail to probe or behave in entirely
unexpected ways.  Hence I deliberately printed an error message
here so that the user can make the connection between erratic
behavior of drivers later on and the memory allocation error here.

You didn't cc me on your submission even though I'm the author of
99% of this file.  Please make an effort prior to submission to
identify interested parties.

Lukas
