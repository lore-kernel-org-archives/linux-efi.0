From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi: Clarify GUID length calculations
Date: Thu, 25 Oct 2012 12:00:38 +0100
Message-ID: <1351162838.5303.4.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1350631005.801791.917065840255.1.gpush@pecola>
	 <1350636874.2429.59.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350636874.2429.59.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2012-10-19 at 09:54 +0100, Matt Fleming wrote:
> (Cc'ing some other folks that might be interested)
> 
> On Fri, 2012-10-19 at 15:16 +0800, Jeremy Kerr wrote:
> > At present, the handling of GUIDs in efivar file names isn't consistent.
> > We use GUID_LEN in some places, and 38 in others (GUID_LEN plus
> > separator), and implicitly use the presence of the trailing NUL.
> > 
> > This change removes the trailing NUL from GUID_LEN, so that we're
> > explicitly adding it when required. We also replace magic numbers
> > with GUID_LEN, and clarify the comments where appropriate.
> > 
> > We also fix the allocation size in efivar_create_sysfs_entry, where
> > we're allocating one byte too much, due to counting the trailing NUL
> > twice - once when calculating short_name_size, and once in the kzalloc.
> > 
> > Signed-off-by: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Applied, thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
