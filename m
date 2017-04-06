From: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 02/24] Add the ability to lock down access to the running
 kernel image
Date: Thu, 6 Apr 2017 18:44:16 +1000 (AEST)
Message-ID: <alpine.LRH.2.20.1704061840090.12226@namei.org>
References: <149141219387.31282.6648284836568938717.stgit@warthog.procyon.org.uk> <149141221365.31282.16276273075946694481.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <149141221365.31282.16276273075946694481.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 5 Apr 2017, David Howells wrote:

> +#include <linux/security.h>
> +#include <linux/export.h>
> +
> +static __read_mostly bool kernel_locked_down;

How about marking this __ro_after_init if ALLOW_LOCKDOWN_LIFT is not 
configured?


-- 
James Morris
<jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
