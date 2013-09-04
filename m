From: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH V3 05/11] asus-wmi: Restrict debugfs interface when module
 loading is restricted
Date: Wed, 4 Sep 2013 10:46:53 +1000 (EST)
Message-ID: <alpine.LRH.2.02.1309041046340.20116@tundra.namei.org>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com> <1378252218-18798-6-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378252218-18798-6-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 3 Sep 2013, Matthew Garrett wrote:

> We have no way of validating what all of the Asus WMI methods do on a
> given machine, and there's a risk that some will allow hardware state to
> be manipulated in such a way that arbitrary code can be executed in the
> kernel, circumventing module loading restrictions. Prevent that if any of
> these features are enabled.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>

Reviewed-by: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>


-- 
James Morris
<jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
