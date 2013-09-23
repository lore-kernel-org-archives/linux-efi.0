From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 10/18] Do proper conversion from UTF-16 to UTF-8
Date: Sun, 22 Sep 2013 17:24:28 -0700
Message-ID: <523F8A3C.7010209@zytor.com>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org> <1379889942-3135-11-git-send-email-roy.franz@linaro.org> <e69e8c38-b195-4797-8ae2-65d69ed9d7aa@email.android.com> <CAFECyb_8hqLFajMUfwctVee8e8UvErmu4jmbPguWaeMc-MZuNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFECyb_8hqLFajMUfwctVee8e8UvErmu4jmbPguWaeMc-MZuNA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 09/22/2013 04:07 PM, Roy Franz wrote:
> On Sun, Sep 22, 2013 at 3:54 PM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
>> Sorry this version is broken and doesn't even compile due to remaining options_size references.
> 
> I compiled and tested this series on both x86_64 (using OVMF) and on
> the ARM simulator.  I just doubled checked
> my kernel .config to verify this was not being omitted and I'm pretty
> sure this doesn't have any compilation problems.
> I did make a few changes to get the untested version you sent out to
> compile, but they all seemed to be straightforward typo type fixes.
> I'll gladly address any defects in this patch, but I don't see an
> compilation problems.
> 

Ah yes, I see now... you fixed up the compile problem but did so
incorrectly.

      int load_options_size = image->load_options_size / 2; /* ASCII */

This is a number of UTF-16 chars, the comment is completely wrong;

-              while (*s2 && *s2 != '\n' && options_size <
load_options_size) {
+              while (*s2 && *s2 != '\n' && options_bytes <
load_options_size) {
+                      options_bytes += efi_utf8_bytes(*s2);
                      s2++;
-                      options_size++;
              }
+              options_chars = s2 - options;

You can't compare options_bytes against load_options_size; the latter
being a UTF-16 shortword count.

So the loop really needs to update options_chars in the loop to compare
it against load_options_size:

	while (*s2 && *s2 != '\n' && options_chars < load_options_size) {
		options_bytes += efi_utf8_bytes(*s2++);
		option_chars++;
	}

	-hpa
