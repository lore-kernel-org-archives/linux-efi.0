From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: [PATCH v6 -next 0/2] make efivars/efi_pstore interrupt-safe
Date: Tue, 12 Feb 2013 21:19:08 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1E059E92@ORSMSX107.amr.corp.intel.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A91283@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A91283@USINDEM103.corp.hds.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Seiji Aguchi <seiji.aguchi@hds.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Cc: "Matt Fleming (matt@console-pimps.org)" <matt@console-pimps.org>, "mikew@google.com" <mikew@google.com>, "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>, "dzickus@redhat.com" <dzickus@redhat.com>, "dle-develop@lists.sourceforge.net" <dle-develop@lists.sourceforge.net>, Satoru Moriya <satoru.moriya@hds.com>
List-Id: linux-efi@vger.kernel.org

> Changelog
> v5 -> v6
>   - Rebase to a latest linux-next tree.
>   - Modify a comment from "efivar_update_sysfs_entry" to 
>     "efivar_update_sysfs_entries" in include/linux/efi.h (Patch 2/2)

Applied to my internal pstore topic branch - which feeds to linux-next. Note
that my branch was based on 3.8-rc2 so I unwound the changes to match
up with Linus latest.  Hope I didn't break anything in the process.

-Tony
