From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [PATCH]Move kzalloc() just before memset() to avoid
 initializing new sysfs entries wrongly
Date: Fri, 10 May 2013 19:10:29 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFF1979@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFF18EF@USINDEM103.corp.hds.com>
 <1368212679.2024.17.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368212679.2024.17.camel@dabdike>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Tomoki Sekiyama <tomoki.sekiyama-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> This is manifestly wrong: it would leak memory as it circulates around
> the loop.

I don't think the memory leak happens.
As you can see below, if  a new entry is not created, kfree() is called outside while(1).

static void efivar_update_sysfs_entries(struct work_struct *work)
{
        struct efivar_entry *entry;
        int err;

        /* Add new sysfs entries */
        while (1) {
        	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
        	if (!entry)
                	return;

                memset(entry, 0, sizeof(*entry));

                err = efivar_init(efivar_update_sysfs_entry, entry,
                                  true, false, &efivar_sysfs_list);
                if (!err)
                        break;

                efivar_create_sysfs_entry(entry);
        }

        kfree(entry);
}
