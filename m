From: Seiji Aguchi <seiji.aguchi@hds.com>
Subject: RE: [PATCH v3 7/7] Add a format check for an existing variable name
 at erasing time
Date: Mon, 29 Oct 2012 20:40:59 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138995EA@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41388F059@USINDEM103.corp.hds.com>
 <CAGTjWtAfaXgx_v46zf_fJ7KhBUTgciU7yedX6w2niER-JQBzTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGTjWtAfaXgx_v46zf_fJ7KhBUTgciU7yedX6w2niER-JQBzTA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Waychison <mikew@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>, "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>, "dzickus@redhat.com" <dzickus@redhat.com>, "dle-develop@lists.sourceforge.net" <dle-develop@lists.sourceforge.net>, Satoru Moriya <satoru.moriya@hds.com>
List-Id: linux-efi@vger.kernel.org

> > +                                 utf16_strlen(efi_name))) {
> > +                       /*
> > +                        * Check if an old format,
> > +                        * which doesn't support holding
> > +                        * multiple logs, remains.
> > +                        */
> > +                       if (sscanf(name, "dump-type%u-%u-%lu",
> > +                                  &type_old, &part_old, &time_old) !=
> > + 3)
> 
> This doesn't look right.  This should probably mirror the sprintf() at the top of the function using a new string, convert it to 16-bit
> Unicodeand then compare it like we do for the 4-variable version above (please ignore the fact that this driver incorrectly calls these
> strings utf16 everywhere -- that needs to be fixed).

I will fix it as well.

Seiji
