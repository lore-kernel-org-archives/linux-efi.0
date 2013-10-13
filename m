From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Add EFI framebuffer earlyprintk support
Date: Sun, 13 Oct 2013 13:47:07 -0700
Message-ID: <525B06CB.6090602@zytor.com>
References: <1381423261-30566-1-git-send-email-matt@console-pimps.org> <20131010172844.GA26430@gmail.com> <20131011140039.GF12321@console-pimps.org> <20131012174934.GA18849@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131012174934.GA18849-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10/12/2013 10:49 AM, Ingo Molnar wrote:
> 
>>>> +static void early_efi_write_char(void *dst, char c, int h)
>>>> +{
>>>> +	const u8 *src;
>>>> +	u32 fgcolor = 0xaaaaaa;
>>>
>>> That's RGB grey, right? Why not 0xffffff for a very visible white?
>>  
>> The VGA earlyprintk code uses the equivalent grey, AFAIK, which is why I 
>> picked this value.
> 
> The VGA code should be changed to white too I suspect ;-)
> 

For compatibility with the classical text console we use light grey as
the default color and a double-stroked font (which was necessary on the
CGA display since it didn't have enough bandwidth to handle
single-stroked fonts well).  The problem with changing that to white is
that you end up with a mismatch between the earlyprintk console and the
"real" console, *or* we change the behavior of everyone's consoles...

	-hpa
