From: shea-yfkUTty7RcRWk0Htik3J/w@public.gmane.org
Subject: Re: Problem mounting efivarfs in 3.9
Date: Thu, 07 Mar 2013 10:00:47 -0500
Message-ID: <2fd64c1f6943602b91c8f28a45243e20@shealevy.com>
References: <20130307145601.GA24233@thinkpad-t410>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130307145601.GA24233@thinkpad-t410>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Seth,

On 2013-03-07 09:56, Seth Forshee wrote:
> Hi Matt,
>
> I found myself unable to mount efivarfs on one of my machines in 3.9.
> This is due to your patch to be more aggressive about validating
> filenames. This machine had some crash dumps from pstore, which start
> with "dump-type". However now efivars expects the guid to follow the
> first '-' character, despite the fact that the efivars pstore code is
> creating the file names starting with dump-type. Since these names 
> fail
> the validation the mount fails.
>

A fix for this is already in mfleming/efi.git: 
http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=urgent&id=123abd76edf56c02a76b46d3d673897177ef067b 
. It's included in the efi-for-3.9-rc2 tag, and cc'd stable.

Cheers,
Shea Levy
