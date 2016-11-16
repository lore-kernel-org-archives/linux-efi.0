From: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [PATCH 00/16] Kernel lockdown
Date: Wed, 16 Nov 2016 22:27:31 +0000
Message-ID: <20161116222731.563fb85e@lxorguk.ukuu.org.uk>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <147933283664.19316.12454053022687659937.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Whether it's a good idea aside

You need to filter or lock down kernel module options because a lot of
modules let you set the I/O port or similar (eg mmio) which means you can
hack the entire machine with say the 8250 driver just by using it with an
mmio of the right location to patch the secure state to zero just by
getting the ability to write to the modules conf file.

Without that at least fixed I don't see the point in merging this. Either
we don't do it (which given the level of security the current Linux
kernel provides, and also all the golden key messups from elsewhere might
be the honest approach), or at least try and do the job right.

Less security is better than fake security. If you've got less security
your take appropriate precautions. If you rely on fake security you don't.

The two other nasty cases you miss should be fine for x86 secure boot -
but maybe not for secure boot in general. That is firmware loading and
initial firewire state. Both should be fine on any 'secure' boot PC.


Alan
