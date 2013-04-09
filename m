From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/6] Chainsaw efivars.c
Date: Tue, 09 Apr 2013 17:50:15 +0100
Message-ID: <516446C7.8080802@intel.com>
References: <1365077935-6859-1-git-send-email-matt@console-pimps.org> <516440F5.7040904@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <516440F5.7040904-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 09/04/13 17:25, H. Peter Anvin wrote:
> On 04/04/2013 05:18 AM, Matt Fleming wrote:
>> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> drivers/firmware/efivars.c has grown pretty large and is ~2K lines.
>>
> 
> Hi Matt,
> 
> Are you expecting me or Matt G. to take this one?

I was going to send it to you in a pull request once it had been
reviewed. It's a pretty invasive change and I was trying to avoid
breaking drivers/firmware/google in particular. I don't think it's
suitable for merging for v3.10, unless Mike and the pstore folks are
happy with it (and make it known fairly soon).
