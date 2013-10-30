From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [PATCH v3] efivars,efi-pstore: Hold off deletion of sysfs entry
 until, the scan is completed
Date: Wed, 30 Oct 2013 19:19:11 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D3F39@USINDEM103.corp.hds.com>
References: <52584373.3010202@hds.com>
 <20131017131821.GH10834@console-pimps.org>
 <A5ED84D3BB3A384992CBB9C77DEDA4D443F0F2D6@USINDEM103.corp.hds.com>
 <20131030143527.GB8193@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131030143527.GB8193-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tomoki Sekiyama <tomoki.sekiyama-7rDLJAbr9SE@public.gmane.org>, "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> On Fri, 18 Oct, at 10:30:58PM, Seiji Aguchi wrote:
> > The scanning and deleting logic is still needed.  In case an entry(A)
> > is found, the pointer is saved to psi->data.  And efi_pstore_read()
> > passes the entry(A) to a pstore filesystem by releasing
> > __efivars->lock.
> >
> > And then, the pstore filesystem calls efi_pstore_read() again and the
> > same entry(A), which is saved to psi->data, is used for re-scanning a
> > sysfs-list.  (That is why list_for_each_entry_safe_from () is used in
> > efi_pstore_sysfs_entry_iter().)
> >
> > So, to protect the entry(A), the logic is needed because, in pstore
> > filesystem,  __efivars->lock Is released.
> 
> Very good point.

Thanks,

I will add the description in the next patch.

Seiji
