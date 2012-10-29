From: Seiji Aguchi <seiji.aguchi@hds.com>
Subject: RE: [PATCH v3 6/7] efi_pstore: Add a format check for an existing
 variable name at reading time
Date: Mon, 29 Oct 2012 20:39:36 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138995BB@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41388F045@USINDEM103.corp.hds.com>
 <CAGTjWtDO=Z9y-7XxE5YdFzWsiT3MZ8Jhb4hgywYCQiG+NGcMKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGTjWtDO=Z9y-7XxE5YdFzWsiT3MZ8Jhb4hgywYCQiG+NGcMKA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Waychison <mikew@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>, "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>, "dzickus@redhat.com" <dzickus@redhat.com>, "dle-develop@lists.sourceforge.net" <dle-develop@lists.sourceforge.net>, Satoru Moriya <satoru.moriya@hds.com>
List-Id: linux-efi@vger.kernel.org

> > +                               efivars->walk_entry = list_entry(
> > +                                       efivars->walk_entry->list.next,
> > +                                        struct efivar_entry, list);
> 
> odd wrap.
> 

I will fix it.

Thanks,

Seiji
