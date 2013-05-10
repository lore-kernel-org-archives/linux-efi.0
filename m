From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [PATCH]Move kzalloc() just before memset() to avoid
 initializing new sysfs entries wrongly
Date: Fri, 10 May 2013 19:34:58 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFF1A05@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFF18EF@USINDEM103.corp.hds.com>
	 <1368212679.2024.17.camel@dabdike>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D41AFF1979@USINDEM103.corp.hds.com>
 <1368214315.2024.20.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368214315.2024.20.camel@dabdike>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Tomoki Sekiyama <tomoki.sekiyama-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org]
> Sent: Friday, May 10, 2013 3:32 PM
> To: Seiji Aguchi
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; Tomoki Sekiyama
> Subject: Re: [PATCH]Move kzalloc() just before memset() to avoid initializing new sysfs entries wrongly
> 
> On Fri, 2013-05-10 at 19:10 +0000, Seiji Aguchi wrote:
> > > This is manifestly wrong: it would leak memory as it circulates around
> > > the loop.
> >
> > I don't think the memory leak happens.
> > As you can see below, if  a new entry is not created, kfree() is called outside while(1).
> 
> Ah, I see, entry is consumed by efivar_create_sysfs_entry(entry)? 

Yes.

> In that case, saying so in the change log would be helpful plus remove the
> memset, which is what implied in the old code that the loop didn't
> consume entry and which is rendered superfluous by the kzalloc.

OK. I will update my patch.
Thank you for reviewing!

Seiji
