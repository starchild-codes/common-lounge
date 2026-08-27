import { createClient, type SupabaseClient } from '@supabase/supabase-js'

declare const __SUPABASE_URL__: string
declare const __SUPABASE_ANON_KEY__: string

let client: SupabaseClient | null = null
try {
  if (__SUPABASE_URL__ && __SUPABASE_ANON_KEY__) {
    client = createClient(__SUPABASE_URL__, __SUPABASE_ANON_KEY__, {
      auth: { flowType: 'pkce', persistSession: true, autoRefreshToken: true, detectSessionInUrl: false },
    })
  }
} catch {
  client = null
}
export const supabase = client
